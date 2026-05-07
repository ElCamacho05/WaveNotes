
# Librosa
import librosa
import numpy as np

# FastAPI
from fastapi import Request, HTTPException

# Others
import time
import io
import zipfile
import tempfile
import os
import torchaudio


async def extract_pitch(request: Request):
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
        
        response = {"status": "success", "notas": final_notes}

        return response

    except Exception as e:
        print(f"Error extrayendo notas: {e}")
        raise HTTPException(status_code=500, detail=str(e))
        
    finally:
        # limpieza de RAM
        if os.path.exists(temp_path):
            os.remove(temp_path)
