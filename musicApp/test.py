# FastAPI
from fastapi import FastAPI, Request, UploadFile, Response, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field, validator

# Demucs
import demucs.api

# Librosa
import librosa
import numpy as np

# Others
import time
import io
import zipfile
import tempfile
import os
import torchaudio


app = FastAPI()


# Instancia del separador de canciones
separator = demucs.api.Separator()

@app.post("/wn/separatorL")
def separate(audio=None, file=None):
    separated = None

    start = time.time()

    try:
        if audio:
            print("Extrayendo audio del usuario...")
            origin, separated = separator.separate_tensor(audio)

        elif file:
            print("Extrayendo de archivo (tests)...")
            origin, separated = separator.separate_audio_file(file)

        else:
            print("No se puede ejecutar la accion")
    
        end = time.time()

    except Exception as e:
        print(f"Error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

    print(f"Separacion finalizada en {end-start} segundos")
    return separated


def save_on_disk(tracks):
    print(tracks)
    print(type(tracks))
    print(tracks.items())
    print(tracks.keys())
    print(tracks.values())

    for stem, source in tracks.items():
        demucs.api.save_audio(source, f"musicApp/output/{stem}_prueba.mp3", samplerate=separator.samplerate)


@app.post("/wn/pitch")
async def extract_pitch(request: Request):
    audio_bytes = await request.body()
    print(f"-- (extract_pitch) Tamanio del paquete: {len(audio_bytes)} bytes")
    
    # condicion por si se envian audios invalidos
    if len(audio_bytes) < 1000:
        raise HTTPException(status_code=400, detail="Error: Archivo vacio o corrupto")

    # guardado temporal en directorio en ram de linux (cosas de linux)
    # NOTA: se recibe el audio de java (extraido por separate_in_memory) como .wav
    with tempfile.NamedTemporaryFile(dir="/tmp", delete=False, suffix=".wav") as temp_audio:
        temp_audio.write(audio_bytes)
        temp_path = temp_audio.name

    try:
        print("-- (extract_pitch) Cargando pista en librosa...")
        y, sr = librosa.load(temp_path, sr=None)

        # extraccion de matriz de frecuencias
        print("-- (extract_pitch) Ejecutando piptrack...")
        pitches, mags = librosa.piptrack(y=y, sr=sr)

        final_notes = []

        # conversion de cada magnitud a notas musicales como str para cada instante de tiempo 
        for t in range(mags.shape[1]):
            # Se obtiene la posicion con la mayor frecuencia en ese tiempo, es la mas representativa
            index = mags[:, t].argmax()
            pitch_hz = pitches[index, t]

            if pitch_hz > 0:
                # Conversion de hz -> a Nota ("A4")
                note = librosa.hz_to_note(pitch_hz)
                
                if len(final_notes) == 0 or final_notes[-1] != note: # solo si es distinta a la ultima
                    final_notes.append((note, t))

        print(f"// (extract_pitch) Extraccion completada: {len(final_notes)} notas encontradas")
        
        return {"status": "success", "notas": final_notes}

    except Exception as e:
        print(f"Error extrayendo notas: {e}")
        raise HTTPException(status_code=500, detail=str(e))
        
    finally:
        # limpieza de RAM
        if os.path.exists(temp_path):
            os.remove(temp_path)


@app.post("/wn/separator")
async def separate_in_memory(request: Request):
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
        return Response(
            content=zip_buffer.getvalue(),
            media_type="application/zip",
            headers={"Content-Disposition": f"attachment; filename=results.zip"}
        )

    finally:
        # Limpieza del MP3 original
        if os.path.exists(temp_path):
            os.remove(temp_path)

# @app.post("/wn/separator")
# async def separate_in_memory(request: Request):
#     # lectura del audio
#     audio_bytes = await request.body()
#     input_buffer = io.BytesIO(audio_bytes)

#     wav, sr = torchaudio.load(input_buffer, format="mp3")

#     # acondicionamiento de tensor (reestructurar el arreglo de tensores para que cumpla los requisitos de demucs)
#     if sr != separator.samplerate:
#             wav = F.resample(wav, sr, separator.samplerate)
    
#     # clonacion para audios mono -> stereo
#     if wav.shape[0] == 1:  # Si el audio es mono, lo clonamos a estéreo
#         wav = wav.repeat(2, 1)
    
#     # separacion de pistas
#     origin, separated = separator.separate_audio_file(input_buffer)
    
#     # compresor zip para las extraidas de la cancion
#     zip_buffer = io.BytesIO()

#     with zipfile.ZipFile(zip_buffer, "w", zipfile.ZIP_DEFLATED) as zip_file:
#         for stem, tensor in separated.items():
#             # tensores quedan atrapados en nuestro buffer dentro de otro mas grande (para formar el diccionario)
#             track_buffer = io.BytesIO()
            
#             # torchaudio.save puede escribir en objetos tipo BytesIO
#             torchaudio.save(
#                 track_buffer,
#                 tensor.to("cpu"),
#                 sample_rate=separator.samplerate,
#                 format="mp3"
#             )
            
#             zip_file.writestr(f"{stem}.mp3", track_buffer.getvalue())
#             track_buffer.close()
    
#     # preparar el paquete para regresarlo
#     zip_buffer.seek(0)
#     return Response(
#         content=zip_buffer.getvalue(),
#         media_type="application/zip",
#         headers={"Content-Disposition": f"attachment; filename=results.zip"}
#     )


if __name__ == '__main__':
    file = "/home/camachess/Escritorio/UNI/S_8/DAW/proyecto/canciones/YTDown_YouTube_K-Cigarettes-After-Sex_Media_L4sbDxR22z4_008_128k.mp3"
    separated = separate(file=file)
    save_on_disk(separated)
    print(separated)
