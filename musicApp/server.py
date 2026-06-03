# librerias locales
import trackSeparator
from instruments.common import pitchExtractor
from instruments.specific import guitar
from instruments.specific import drums
import musicDownloader

# FastAPI
from fastapi import FastAPI, Request, UploadFile, Response, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field, validator


app = FastAPI()


# Instancia del separador de canciones
@app.post("/wn/download")
async def downloadMusicEndpoint():
    # TODO
    pass


@app.post("/wn/drums")
async def pitchEndpoint(request: Request):
    response = await drums.extract_drums(request)
    return response


@app.post("/wn/bass")
async def pitchEndpoint(request: Request):
    response = await pitchExtractor.extract_pitch(request)
    return response


@app.post("/wn/guitar")
async def pitchEndpoint(request: Request):
    response = await guitar.extract_chords(request)
    return response

@app.post("/wn/pitch")
async def pitchEndpoint(request: Request):
    response = await pitchExtractor.extract_pitch(request)
    return response


@app.post("/wn/separator")
async def separateEndpoint(request: Request):
    print("-- (server) Separando pistas...")
    result = await trackSeparator.separate(request)

    return Response(
            content=result['content'],
            media_type=result['media_type'],
            headers=result['headers']
        )


if __name__ == '__main__':
    file = "/home/camachess/Escritorio/UNI/S_8/DAW/proyecto/canciones/YTDown_YouTube_K-Cigarettes-After-Sex_Media_L4sbDxR22z4_008_128k.mp3"
    separated = separate(file=file)
    save_on_disk(separated)
    print(separated)
