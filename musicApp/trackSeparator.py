# Demucs
import demucs.api

# Others
import time
import io
import zipfile
import tempfile
import os
import torchaudio

# 
from fastapi import Request, HTTPException

separator = demucs.api.Separator()


async def separate(request: Request):
    audio_bytes = await request.body()
    print(f"-- (separate_in_memory) Tamanio del paquete: {len(audio_bytes)} bytes")
    
    # condicion por si se envian audios invalidos
    if len(audio_bytes) < 1000:
        raise HTTPException(status_code=400, detail="Error: Archivo vacio o corrupto")

    # guardado temporal en directorio en ram de linux (cosas de linux)
    with tempfile.NamedTemporaryFile(dir="/tmp", delete=False, suffix=".mp3") as temp_audio:
        temp_audio.write(audio_bytes)
        temp_path = temp_audio.name

    try:
        # separacion de pistas
        origin, separated = separator.separate_audio_file(temp_path)
        print("// (separate_in_memory) Separacion exitosa, empaquetando...")

        # compresor zip para las extraidas de la cancion
        zip_buffer = io.BytesIO()
        
        with zipfile.ZipFile(zip_buffer, "w", zipfile.ZIP_DEFLATED) as zip_file:
            for stem, tensor in separated.items():
                temp_stem_path = f"/tmp/wavenotes_{stem}.mp3"
                
                # guardado de archivo en /tmp de linux en ram
                demucs.api.save_audio(tensor, temp_stem_path, samplerate=separator.samplerate)
                
                # lectura en tmp e inyeccion a zip_file
                zip_file.write(temp_stem_path, arcname=f"{stem}.mp3")
                
                # borrado en ram para evitar que se sature de pistas
                os.remove(temp_stem_path)

        # preparar el paquete para regresarlo
        zip_buffer.seek(0)
        print("// (separate_in_memory) Guardado en zip finalizado")

        response = {
            'content': zip_buffer.getvalue(),
            'media_type': "application/zip",
            'headers': {"Content-Disposition": f"attachment; filename=results.zip"}
        }

        return response

    finally:
        # Limpieza del MP3 original
        if os.path.exists(temp_path):
            os.remove(temp_path)
