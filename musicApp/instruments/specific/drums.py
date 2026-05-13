import librosa
import numpy as np
import tempfile
import os
from fastapi import Request, HTTPException


async def extract_drums(request: Request):
    audio_bytes = await request.body()
    print(f"-- (extract_pitch) Tamanio del paquete: {len(audio_bytes)} bytes")
    
    # condicion por si se envian audios invalidos
    if len(audio_bytes) < 1000:
        raise HTTPException(status_code=400, detail="Error: Archivo vacio o corrupto")
    else:
        print("-- (extract_pitch) Archivo leido correctamente")

    # guardado temporal en directorio en ram de linux (cosas de linux)
    # NOTA: se recibe el audio de java (extraido por separate_in_memory) como .wav
    with tempfile.NamedTemporaryFile(dir="/tmp", delete=False, suffix=".wav") as temp_audio:
        temp_audio.write(audio_bytes)
        temp_path = temp_audio.name

    try:
        print("-- (extract_pitch) Cargando pista en librosa...")
        y, sr = librosa.load(temp_path, sr=None)

        # deteccion del onset de los golpes a la bateria
        # detecta los momentos de mayor ruido en el auido de la bateria
        # para retornarlos
        beat_moments = librosa.onset.onset_detect(y=y, sr=sr, units='time')

        final_beats = beat_moments.tolist()

        print(f"!! Extracción completada: {len(final_beats)} golpes de batería detectados")

        return {"status": "success", "notas": final_beats}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if os.path.exists(temp_path):
            os.remove(temp_path)