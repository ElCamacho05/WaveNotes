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
        print("-- (extract_chords) Cargando pista en librosa...")
        y, sr = librosa.load(temp_path, sr=22050)

        # extraccion fel Cromagrama
        chroma = librosa.feature.chroma_cqt(y=y, sr=sr)
        
        time_frames = chroma.shape[1]
        detected_chors = []
        
        # analisis por segmentos de 20 frames musicales
        for i in range(0, time_frames, 20):  
            segmento = chroma[:, i:i+20]
            e_mean = np.mean(segmento, axis=1)
            
            norm = np.linalg.norm(e_mean) # normalizacion
            if norm > 0:
                e_mean = e_mean / norm
            
            best_chord_match = None
            max_score = -1
            
            # comparacion del audio contra los 24 acordes
            for chord_name, template in CHORD_TEMPLATES.items():
                # producto punto necesaroio para la comparacion
                # mientras mas alto sea el score mas cerca esta de ser igual a ese acorde
                score = np.dot(e_mean, template)
                if score > max_score:
                    max_score = score
                    best_chord_match = chord_name
            
            # filtrado de ruido, por si se colo por ahi algun ruido de fondo
            # que se haya tomado como maximo aunque no lo sea
            # falso positivo
            if max_score > 0.4: 
                # evitar acordes repetidos en la misma ventana
                if len(detected_chors) == 0 or detected_chors[-1] != best_chord_match:
                    detected_chors.append(best_chord_match)

        print(f"!! (extract_chords) Extraccion completada: {len(detected_chors)} acordes encontrados")
        
        return {"status": "success", "notas": detected_chors}

    except Exception as e:
        print(f"Error extrayendo acordes: {e}")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if os.path.exists(temp_path):
            os.remove(temp_path)