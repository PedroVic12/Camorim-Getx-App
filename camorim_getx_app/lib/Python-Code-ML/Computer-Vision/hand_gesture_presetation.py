from cvzone.HandTrackingModule import HandDetector
import cv2
import os
import numpy as np
import time


class PresentationController:
    def __init__(self):
        self.width, self.height = 900, 450
        self.gestureThreshold = 300
        self.folderPath = (
            "camorim_getx_app/lib/Python-Code-ML/Computer-Vision/presetation"
        )
        self.detectorHand = HandDetector(detectionCon=0.8, maxHands=1)
        self.presentation = Presentation(self.folderPath, self.width, self.height)
        self.handGestureController = HandGestureController(
            self.detectorHand, self.gestureThreshold
        )

    def run(self):
        cap = cv2.VideoCapture(0)
        cap.set(3, self.width)
        cap.set(4, self.height)

        while True:
            # setup
            success, img = cap.read()
            img = cv2.flip(img, 1)
            self.presentation.updateCurrentImage()

            #
            hands, img = self.detectorHand.findHands(img, flipType=False)

            # Processa os gestos das mãos
            self.handGestureController.moverTelasApresentacao(hands, self.presentation)

            self.handGestureController.desenharLinhas(img=img, width=self.width)

            # Reduz a apresentação
            img_reduzida = cv2.resize(self.presentation.imgCurrent, dsize=(500, 500))
            cv2.imshow("Slides", img_reduzida)
            cv2.imshow("Image", img)

            # Controle de saída
            if cv2.waitKey(1) == ord("q"):
                break


class HandGestureController:
    def __init__(self, detectorHand, gestureThreshold):
        self.detectorHand = detectorHand
        self.gestureThreshold = gestureThreshold
        self.buttonPressed = False
        self.counter = 0
        self.delay = 30

    def delay(self, s):
        time.sleep(s)

    def moverTelasApresentacao(self, hands, presentation):
        if hands and not self.buttonPressed:
            hand = hands[0]
            handType = hand["type"]  # Pega o tipo de mão (esquerda ou direita)
            fingers = self.detectorHand.fingersUp(hand)
            print("Mão: ", handType, ", Dedos Levantados: ", fingers)
            cx, cy = hand["center"]

            if cy <= self.gestureThreshold:
                # Gesture 1 - Movimento para Esquerda/Direita
                if fingers == [1, 1, 0, 0, 0]:
                    if handType == "Left":  # Mão esquerda: decrementa o contador
                        if presentation.imgNumber > 0:
                            presentation.imgNumber -= 1
                            print("Movendo para a imagem anterior")
                    elif handType == "Right":  # Mão direita: incrementa o contador
                        if presentation.imgNumber < len(presentation.pathImages) - 1:
                            presentation.imgNumber += 1
                            print("Movendo para a próxima imagem")
                    self.buttonPressed = True

        # Controle de delay para evitar múltiplas detecções
        if self.buttonPressed:
            self.counter += 1
            if self.counter > self.delay:
                self.counter = 0
                self.buttonPressed = False

    def desenharLinhas(self, img, width):
        cv2.line(
            img,
            (0, self.gestureThreshold),
            (width, self.gestureThreshold),
            (0, 255, 0),
            10,
        )


class Presentation:
    def __init__(self, folderPath, width, height):
        self.folderPath = folderPath
        self.width = width
        self.height = height
        self.imgNumber = 0
        self.annotations = [[]]
        self.annotationNumber = -1
        self.pathImages = sorted(os.listdir(folderPath), key=len)
        self.imgCurrent = None
        self.updateCurrentImage()

    def updateCurrentImage(self):
        pathFullImage = os.path.join(self.folderPath, self.pathImages[self.imgNumber])
        print(pathFullImage)
        self.imgCurrent = cv2.imread(pathFullImage)


def main():
    # Cria uma instância do controlador da apresentação
    presentationController = PresentationController()

    # Executa o controlador da apresentação
    presentationController.run()


main()
