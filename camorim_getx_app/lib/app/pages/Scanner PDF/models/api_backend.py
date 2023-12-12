from fastapi import FastAPI, File, UploadFile, Request
from fastapi.responses import JSONResponse
import pytesseract
from PIL import Image
import io
import json
import werkzeug
import shutil
import os
import cv2
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Permite todas as origens
    allow_credentials=True,
    allow_methods=["*"],  # Permite todos os métodos
    allow_headers=["*"],  # Permite todos os cabeçalhos
)


class ImageProcessor:
    def __init__(self):
        pass

    def extract_text(self, image_file):
        image = Image.open(image_file)
        text = pytesseract.image_to_string(image, lang='por')
        return text

    def extrair_textoImagem(self, image):
        text = pytesseract.image_to_string(image, lang='por')
        return text


image_processor = ImageProcessor()


@app.post("/upload-image/")
async def upload_image(file: UploadFile = File(...)):
    global ocr_text

    folder = "./images"
    os.makedirs(folder, exist_ok=True)
    filename = f"{folder}/{file.filename}"
    print(file.file)

    try:
        with open(filename, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
    except:
        print('Erro')

    # Processamento da imagem com OpenCV
    image = cv2.imread(filename)
    print(image)
    ocr_text = pytesseract.image_to_string(image, lang='por')

    return {"ocr_text": ocr_text}


@app.get("/get-text/")
def get_text():
    global ocr_text

    #print(ocr_text)
    return JSONResponse(content={"extracted_text": ocr_text})


@app.post("/enviar-foto/",)
def index():
    # Image
    imagefile = Request.files["image"]
    # Getting file name of the image using werkzeug library
    filename = werkzeug.utils.secure_filename(imagefile.filename)
    print("\nReceived image File name : " + imagefile.filename)
    # Saving the image in images Directory
    imagefile.save("images/" + filename)
    # Passing the imagePath in this giveFacesCoordinates function and getting the list of faces coordinate
    foto = ocr_text = image_processor.extract_text("./images/" + filename)
    # Returns faces Cordinate in the json Format
    return json.dumps({"fotos": foto})


@app.get('/')
def index():
    return {"message": "Hello World"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
