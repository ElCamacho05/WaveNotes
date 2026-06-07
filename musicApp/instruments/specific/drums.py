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
        freqs = librosa.fft_frequencies(sr=sr)

        band_kick      = (freqs > 20) & (freqs < 80)     # Bombo
        band_floor_tom = (freqs > 80) & (freqs < 150)    # Tom de Piso
        band_snare     = (freqs > 150) & (freqs < 400)    # Tarola / Caja
        band_high_tom  = (freqs > 400) & (freqs < 1500)   # Toms altos/medios
        band_hihat     = (freqs > 4000) & (freqs < 8000)   # Hi-hat
        band_crash     = (freqs > 8000)                    # Crash / Ride

        clasif = []

        for i, frame in enumerate(beat_frames):
            ie = S[:, frame]
            
            e_kick = np.mean(ie[band_kick]) if np.any(band_kick) else 0
            e_floor_tom = np.mean(ie[band_floor_tom]) if np.any(band_floor_tom) else 0
            e_snare = np.mean(ie[band_snare]) if np.any(band_snare) else 0
            e_high_tom = np.mean(ie[band_high_tom]) if np.any(band_high_tom) else 0
            e_hihat = np.mean(ie[band_hihat]) if np.any(band_hihat) else 0
            e_crash = np.mean(ie[band_crash]) if np.any(band_crash) else 0
            
            e = {
                0: e_kick,       # 0 = KICK
                1: e_snare,      # 1 = SNARE
                2: e_hihat,      # 2 = HIHAT
                3: e_high_tom,   # 3 = HIGH TOM
                4: e_floor_tom,  # 4 = FLOOR TOM
                5: e_crash       # 5 = CRASH/RIDE
            }
            
            tipo_ganador = max(e, key=e.get)
                
            rt_seconds = float(beat_times[i])
            clasif.append({"targetDrum": tipo_ganador, "time": rt_seconds})
        
        print(f"!! Extraccion completada: {len(clasif)} golpes detectados")

        return {"status": "success", "notas": clasif}
    except Exception as e:
        logging.exception("An error occurred during calculation")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        print()
        if os.path.exists(temp_path):
            os.remove(temp_path)