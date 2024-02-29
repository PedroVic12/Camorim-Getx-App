import pymongo
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


def enviar_email():
    # Configurar servidor SMTP
    server = smtplib.SMTP("smtp.example.com", 587)
    server.starttls()
    server.login("seu_email@example.com", "sua_senha")

    # Criar mensagem de e-mail
    msg = MIMEMultipart()
    msg["From"] = "seu_email@example.com"
    msg["To"] = "destinatario@example.com"
    msg["Subject"] = "Alteração no banco de dados"

    body = "Uma alteração foi feita no banco de dados."
    msg.attach(MIMEText(body, "plain"))

    # Enviar e-mail
    server.send_message(msg)
    server.quit()


# Conectar ao servidor MongoDB
client = pymongo.MongoClient("mongodb://localhost:27017/")

# Selecionar o banco de dados
db = client["meu_banco_de_dados"]

# Obter a coleção de relatórios
relatorios = db["relatorios"]

# Observar alterações na coleção
pipeline = [{"$match": {"operationType": {"$in": ["insert", "update", "delete"]}}}]
with relatorios.watch(pipeline) as stream:
    for change in stream:
        print(change)
        # Envie um e-mail de notificação

enviar_email()