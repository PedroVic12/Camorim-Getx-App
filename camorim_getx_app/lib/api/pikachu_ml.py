import cv2
from PIL import Image
import numpy as np
import pytesseract as pt
import pandas as pd

import re
import io
import os

from google.cloud import vision

import matplotlib.pyplot as plt

# from spellchecker import SpellChecker
import spacy
# import nltk

# Instanciar o cliente
#os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = r'C:\Users\PedroVictorRodrigues\Documents\GitHub\elon-musk\Tecnologia e Inovação\Visão Computacional\src\open_cv_demo\client_file.json'
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = r'/home/pedrov/Documentos/GitHub/Camorim-Getx-App/camorim_getx_app/lib/api/client_file.json'

client = vision.ImageAnnotatorClient()
print(client)


class Pikachu:
    def __init__(self, imagem_path=None, imagem_bytes=None):
        if imagem_path is None and imagem_bytes is None:
            raise ValueError(
                "Um caminho para a imagem ou bytes da imagem devem ser fornecidos")

        self.imagem_path = imagem_path
        self.imagem_bytes = imagem_bytes

        #! Inicializando
        self.imagem = self.abrir_imagem_cv2()
        self.imagem_processada = self.ProcessarImagem()

        #!Tesseract
        pt.pytesseract.tesseract_cmd = r'C:\Users\PedroVictorRodrigues\AppData\Local\Programs\Tesseract-OCR\tesseract.exe'
        self.client = vision.ImageAnnotatorClient()

    #! Inicializadno
    def abrirImagemVision(self):
        with io.open(self.imagem_path, 'rb') as imagem_file:
            conteudo = imagem_file.read()

        img = vision.Image(content=conteudo)
        return img.content

    def abrir_imagem(self):
        imagem = Image.open(self.imagem_path)
        return imagem

    def abrirImagemAplicativo(self):
        if self.imagem_bytes:
            return Image.open(io.BytesIO(self.imagem_bytes))
        return Image.open(self.imagem_path)

    def abrir_imagem_cv2(self):
        img = self.abrir_imagem()
        imagem_np = cv2.cvtColor(np.array(img), cv2.COLOR_RGB2BGR)
        return imagem_np

    def verConteudoImagem(self, imagem_processada):
        img_encode = cv2.imencode('.jpg', imagem_processada)[1]
        img_content = img_encode.tobytes()
        return img_content

    def get_imagem(self, _img_object=None):
        if _img_object is None:
            _img_object = self.imagem
        plt.imshow(_img_object)
        plt.show()
        return _img_object

    #! Processamento

    def ProcessarImagem(self):

        foto = self.abrirImagemVision()

        # Convertendo a imagem para um array NumPy
        img_array = np.array(bytearray(foto), dtype=np.uint8)
        img_cv = cv2.imdecode(img_array, cv2.IMREAD_COLOR)

        # Convertendo a imagem para escala de cinza
        gray = cv2.cvtColor(img_cv, cv2.COLOR_BGR2GRAY)

        # Aplicar limiarização adaptativa para remover o fundo
        _, img_limiarizada = cv2.threshold(
            gray, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)

        # Aplicando a detecção de bordas para destacar as regiões de texto
        # edges = cv2.Canny(img_limiarizada, 50, 200)

        # Convertendo a imagem de volta para BGR
        img_bgr = cv2.cvtColor(img_limiarizada, cv2.COLOR_GRAY2BGR)

        # Salvar a imagem limiarizada
        self.save_image('img_processada.jpg', img_bgr)
        return img_limiarizada

    def ProcessarImagemServidor(self):

        foto = self.abrirImagemAplicativo()

        # Convertendo a imagem para um array NumPy
        img_array = np.array(bytearray(foto), dtype=np.uint8)
        img_cv = cv2.imdecode(img_array, cv2.IMREAD_COLOR)

        # Convertendo a imagem para escala de cinza
        gray = cv2.cvtColor(img_cv, cv2.COLOR_BGR2GRAY)

        # Aplicar limiarização adaptativa para remover o fundo
        _, img_limiarizada = cv2.threshold(
            gray, 0, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)

        # Aplicando a detecção de bordas para destacar as regiões de texto
        # edges = cv2.Canny(img_limiarizada, 50, 200)

        # Convertendo a imagem de volta para BGR
        img_bgr = cv2.cvtColor(img_limiarizada, cv2.COLOR_GRAY2BGR)

        # Salvar a imagem limiarizada
        self.save_image('img_processada.jpg', img_bgr)
        return img_limiarizada

    def save_image(self, filename, _img_object):
        cv2.imwrite(filename, _img_object)
        return f'\nImagem Salva em: {filename}'

    def converter_para_preto_e_branco(self, img=None):
        if img is None:
            img = self.imagem

        # Converta a imagem para escala de cinza
        gray_image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

        # Retorne a imagem em escala de cinza
        return gray_image

    def binarizar_imagem(self, img=None):
        """
        Binariza uma imagem, tornando o texto preto e o fundo branco.

        Parâmetros:
        - caminho_imagem: string contendo o caminho completo da imagem.

        Retorna:
        - binarizada_invertida: imagem binarizada com texto preto e fundo branco.
        - score: métrica de contraste da imagem.
        """
        if img is None:
            img = self.imagem_path

        # Carregando a imagem
        img_object = cv2.imread(img, cv2.IMREAD_GRAYSCALE)

        # Aplicando filtro bilateral para preservar bordas e reduzir ruído
        img_object = cv2.bilateralFilter(img_object, 9, 75, 75)

        # Limiarização adaptativa
        binarizada = cv2.adaptiveThreshold(
            img_object, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 11, 2)

        # Invertendo a imagem (para ter fundo branco e texto preto)
        binarizada_invertida = 255 - binarizada

        # Calculando o score
        score = np.mean(binarizada_invertida)
        print('score', score)

        return binarizada_invertida, score

    #! Metodos de Texto

    def extrair_texto_tesseract(self):
        # Converta a imagem em escala de cinza
        gray_image = cv2.cvtColor(self.imagem, cv2.COLOR_BGR2GRAY)

        # Execute o OCR na imagem em escala de cinza
        texto = pt.image_to_string(gray_image, lang='por')

        return texto

    def extrairTextoRegiao(self, palavra_chave, imagem_processada):
        img_content = self.verConteudoImagem(imagem_processada)
        image = vision.Image(content=img_content)
        response = self.client.document_text_detection(
            image=image, image_context={'language_hints': ['pt-t-i0-handwrit']})
        texto = response.full_text_annotation.text

        # Obter as coordenadas da região correspondente à palavra-chave
        regiao = self.obterRegiaoPalavraChave(palavra_chave, response)

        # Verificar se a região foi encontrada
        if regiao is None:
            return ''

        # Converter a imagem para escala de cinza
        img_cv = cv2.imdecode(np.frombuffer(
            img_content, np.uint8), cv2.IMREAD_GRAYSCALE)

        # Obter as coordenadas da região retangular centrada na palavra-chave
        x_min = regiao.vertices[0].x - 50
        y_min = regiao.vertices[0].y - 50
        x_max = regiao.vertices[2].x + 50
        y_max = regiao.vertices[2].y + 50

        # Certificar-se de que as coordenadas estão dentro dos limites da imagem
        x_min = max(x_min, 0)
        y_min = max(y_min, 0)
        x_max = min(x_max, img_cv.shape[1])
        y_max = min(y_max, img_cv.shape[0])

        # Extrair a região retangular da imagem correspondente à palavra-chave
        regiao_imagem = img_cv[y_min:y_max, x_min:x_max]

        # Verificar se a região tem tamanho suficiente para processamento
        if regiao_imagem.shape[0] < 10 or regiao_imagem.shape[1] < 10:
            return "Não foi possível ler o texto na região"

        # Aplicar OCR na região da imagem para extrair o texto manuscrito
        texto_manuscrito = self.extrairTextoManuscrito(regiao_imagem)

        if not texto_manuscrito:
            return "Não foi possível ler o texto na região"

        return texto_manuscrito

    def obterRegiaoPalavraChave(self, palavra_chave, response):
        for page in response.full_text_annotation.pages:
            for block in page.blocks:
                for paragraph in block.paragraphs:
                    for word in paragraph.words:
                        palavra = ' '.join(
                            [symbol.text for symbol in word.symbols])

                        # Verificar se a palavra contém a palavra-chave
                        if palavra_chave in palavra:
                            return word.bounding_box

        return None

    def extrairTextoManuscrito(self, imagem):
        img_content = self.verConteudoImagem(imagem)
        image = vision.Image(content=img_content)
        response = self.client.document_text_detection(
            image=image, image_context={'language_hints': ['pt-t-i0-handwrit']})
        texto_manuscrito = response.full_text_annotation.text
        return texto_manuscrito

    #! Buscando informalçoes

    def obter_dados_imagem(self):
        imagem = self.abrir_imagem()
        img_cv2 = self.abrir_imagem_cv2()

        dados_imagem = pt.image_to_data(imagem, lang='por')

        return dados_imagem

    def ler_texto_tabela(self, imagem_processada):
        img_content = self.verConteudoImagem(imagem_processada)
        image = vision.Image(content=img_content)
        response = self.client.document_text_detection(
            image=image, image_context={'language_hints': ['pt-t-i0-handwrit']})

        tabelas = []
        for page in response.full_text_annotation.pages:
            for block in page.blocks:
                if block.block_type == vision.Block.BlockType.TABLE:
                    tabela = []
                    for row in block.table.rows:
                        linha_tabela = []
                        for cell in row.cells:
                            palavra = ' '.join(
                                [symbol.text for symbol in cell.symbols])
                            linha_tabela.append(palavra)
                        tabela.append(linha_tabela)
                    tabelas.append(tabela)

        return tabelas

    def data_to_dataframe(self):
        # Parâmetros
        imagem = self.abrir_imagem()
        img_cv2 = self.abrir_imagem_cv2()
        img_height, img_width, _ = np.array(img_cv2).shape
        vermelho_rgb = (0, 0, 255)

        dados_imagem = pt.image_to_data(imagem, lang='por')

        # Lista para armazenar os dados formatados
        dados_formatados = []

        # Loop em cada linha para formatar os dados
        for linha in dados_imagem.splitlines():
            linha = linha.split()

            if len(linha) == 12:
                if linha[6] == 'left':  # Verifica se a string 'left' está presente na lista
                    continue  # Ignora a linha e passa para a próxima iteração

                x, y, w, h = int(linha[6]), int(
                    linha[7]), int(linha[8]), int(linha[9])
                palavra = linha[11]

                # Verifica se o texto é composto apenas por caracteres alfanuméricos
                if re.match(r'^[a-zA-Z0-9]+$', palavra):
                    # Armazena os dados formatados na lista
                    dados_formatados.append(
                        {'Texto': palavra, 'Coordenada X': x, 'Coordenada Y': y})

        # Exibe a imagem com os retângulos
        self.exibir_imagem(img_cv2)

        # Cria o DataFrame com os dados formatados
        df_dados_imagem = pd.DataFrame(dados_formatados)

        return df_dados_imagem

    #! Pegando coordenadas

    def get_localizacao_texto(self, texto):
        imagem = self.abrir_imagem()
        img_np = self.abrir_imagem_cv2()

        boxes = pt.image_to_boxes(imagem, lang='por')
        img_height, img_width, _ = np.array(imagem).shape
        coordenadas = []

        for box in boxes.splitlines():
            box = box.split(' ')
            palavra = box[0]
            x, y, largura, altura = int(box[1]), int(
                box[2]), int(box[3]), int(box[4])

            # Verifica se a palavra na caixa coincide com o texto fornecido
            if palavra == texto:
                coordenadas.append(
                    {'Texto': palavra, 'Coordenada X': x, 'Coordenada Y': img_height - y})

                # Desenha um retângulo em torno da palavra encontrada
                vermelho_rgb = (0, 0, 255)
                cv2.rectangle(img_np, (x, img_height - y),
                              (largura, img_height - altura), vermelho_rgb, 1)

        self.exibir_imagem(img_np)

        return coordenadas

    def get_coordenadas_txt(self):
        imagem = self.abrir_imagem()
        img_np = self.abrir_imagem_cv2()

        boxes = pt.image_to_boxes(imagem, lang='por')
        img_height, img_width, _ = np.array(imagem).shape
        for box in boxes.splitlines():
            box = box.split(' ')
            letra, x, y, largura, altura = box[0], int(
                box[1]), int(box[2]), int(box[3]), int(box[4])
            vermelho_rgb = (0, 0, 255)

            cv2.rectangle(img_np, (x, img_height-y),
                          (largura, img_height-altura), vermelho_rgb, 1)
        self.exibir_imagem(img_np)

    #!Output

    def exibir_imagem(self, _objeto_imagem):
        cv2.imshow('Imagem', _objeto_imagem)
        cv2.waitKey(0)
        cv2.destroyAllWindows()
