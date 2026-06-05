import librosa
import numpy as np
import tempfile
import os
from fastapi import Request, HTTPException
import logging


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
        # detecta los momentos de mayor ruido en el auido de la bateria para retornarlos
        beat_frames = librosa.onset.onset_detect(y=y, sr=sr, units='frames')
        
        # convertir frames a segundos exactos
        beat_times = librosa.frames_to_time(beat_frames, sr=sr)

        # espectrograma de las notas
        S = np.abs(librosa.stft(y))

        freqs = librosa.fft_freqs(sr=sr)

        low_band = (freqs > 20) & (freqs < 150)     # rango del Bombo
        mid_band = (freqs > 150) & (freqs < 2000)   # rango de Tarola
        high_band = (freqs > 4000)                        # rango de Platillos

        clasif = []

        for i, frame in enumerate(beat_frames):
            ie = S[:, frame]
            
            e_bass_drum = np.sum(ie[low_band])          # bombo
            e_snare = np.sum(ie[mid_band])              # caja/tarola
            e_hi_hat = np.sum(ie[high_band])            # platillos
            
            if e_bass_drum > energia_tarola and e_bass_drum > e_hi_hat:
                tipo = 0 # KICK
            elif e_hi_hat > e_bass_drum and e_hi_hat > energia_tarola:
                tipo = 2 # HIHAT
            else:
                tipo = 1 # SNARE
                
            rt_seconds = float(beat_times[i])
            clasif.append({"targetDrum": tipo, "time": rt_seconds})
        
        print(f"!! Extracción completada: {len(clasif)} golpes de batería detectados")

        return {"status": "success", "notas": clasif}
    except Exception as e:
        logging.exception("An error occurred during calculation")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        print()
        if os.path.exists(temp_path):
            os.remove(temp_path)