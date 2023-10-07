from flask import Flask, request, jsonify
import cv2
import numpy as np
import base64
import os

from pikachu_ml import Pikachu


class RaichuServerWeb:
    def __init__(self):
        self.app = Flask(__name__)
        self.setup_routes()
        # self.pikachu = Pikachu()

    def setup_routes(self):
        @self.app.route('/upload_image', methods=['POST'])
        def upload_image():
            return self.processarTextoDaImagem()

        @self.app.route('/', methods=['GET'])
        def index():
            return "<h1> Raichu Server is online!</h1>"

    def processarTextoDaImagem(self):

        try:
            encoded_image = request.form['image']
            decoded_image = base64.b64decode(encoded_image)
            nparr = np.frombuffer(decoded_image, np.uint8)
            img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

            # extrair o texto
            texto_manuscrito = self.extrairTextoManuscrito(img)

            # Retorna algum resultado se desejado
            return jsonify(result=texto_manuscrito)
        except:
            return {'message': 'Erro ao Processar a imagem'}

    def extrairTextoManuscrito(self, img):

        try:
            # PATH_IMAGEM = r'C:\Users\PedroVictorRodrigues\Documents\GitHub\elon-musk\Tecnologia e Inovação\Visão Computacional\assets\Train Data\pagina_1.jpg'
            pikachu = Pikachu(imagem_bytes=img)

            # Processando imagem
            img_processada = pikachu.abrirImagemAplicativo()

            # Extraindo texto
            txt = pikachu.extrairTextoManuscrito(img_processada)
            return txt
        except:
            return {'message': 'Erro ao extrair o texto da imagem'}

    def run(self):
        self.app.run(debug=True)


if __name__ == "__main__":
    raichu = RaichuServerWeb()
    raichu.run()
