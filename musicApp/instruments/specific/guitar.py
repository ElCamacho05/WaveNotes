import librosa
import numpy as np
import tempfile
import os
from fastapi import Request, HTTPException

NOTAS = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']

# generacion de plantillas para los 24 acordes basicos
CHORD_TEMPLATES = {}
for i, root in enumerate(NOTAS):
    # Acorde Mayor: Raíz (0), Tercera Mayor (4), Quinta Justa (7)
    maj_template = np.zeros(12)
    maj_template[i] = 1
    maj_template[(i + 4) % 12] = 1
    maj_template[(i + 7) % 12] = 1
    CHORD_TEMPLATES[root] = maj_template

    # Acorde Menor: Raíz (0), Tercera Menor (3), Quinta Justa (7)
    min_template = np.zeros(12)
    min_template[i] = 1
    min_template[(i + 3) % 12] = 1
    min_template[(i + 7) % 12] = 1
    CHORD_TEMPLATES[f"{root}m"] = min_template


async def extract_chords(request: Request):
    audio_bytes = await request.body()
    print(f"-- (extract_chords) Tamanio del paquete: {len(audio_bytes)} bytes")
    
    if len(audio_bytes) < 1000:
        raise HTTPException(status_code=400, detail="Error: Archivo vacio o corrupto")

    with tempfile.NamedTemporaryFile(dir="/tmp", delete=False, suffix=".wav") as temp_audio:
        temp_audio.write(audio_bytes)
        temp_path = temp_audio.name

    try:
        print("-- (extract_chords) Cargando pista en librosa...")
        y, sr = librosa.load(temp_path, sr=None)

        beat_frames = librosa.onset.onset_detect(y=y, sr=sr, units='frames')
        beat_times = librosa.frames_to_time(beat_frames, sr=sr)

        # extraccion fel Cromagrama
        chroma = librosa.feature.chroma_stft(y=y, sr=sr)
        
        clasif = []

        # analisis continuo en rangos de 10 frames
        for i, frame in enumerate(beat_frames):
            end_frame = min(frame + 10, chroma.shape[1])
            chroma_window = chroma[:, frame:end_frame]
            
            # promedio de esa fraccion de segundo
            e_mean = np.mean(chroma_window, axis=1)
            
            norm = np.linalg.norm(e_mean)
            if norm > 0:
                e_mean = e_mean / norm
            
            best_chord_match = None
            max_score = -1
            
            for chord_name, template in CHORD_TEMPLATES.items():
                score = np.dot(e_mean, template)
                if score > max_score:
                    max_score = score
                    best_chord_match = chord_name
            
            if max_score > 0.4: 
                rt_seconds = float(beat_times[i])
                clasif.append({
                    "chord": best_chord_match, 
                    "time": rt_seconds
                })

        print(f"!! (extract_chords) Extraccion completada: {len(clasif)} acordes encontrados")
        
        return {"status": "success", "notas": clasif}

    except Exception as e:
        print(f"Error extrayendo acordes: {e}")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if os.path.exists(temp_path):
            os.remove(temp_path)