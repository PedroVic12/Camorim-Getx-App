async def send_email_files(
    arquivo_pdf: UploadFile = File(...), arquivo_excel: UploadFile = File(...)
):
    try:
        # Configuração do e-mail
        remetente = "pedrovictor.rveras12@gmail.com"
        destinatario = [
            "pedroveras@camorim.com.br",
            "pedrovictorveras@id.uff.br",
        ]
        assunto = "Relatório de Ordem de Serviço"
        senha = "mftyjnqmarqldwut"

        msg = MIMEMultipart()
        msg["Subject"] = assunto
        msg["From"] = remetente
        msg["To"] = destinatario[0]

        # Corpo do e-mail
        corpo_email = """
            <h1>Olá, tudo bem?</h1>
            <p>Segue em anexo o relatório de Ordem de Serviço.</p>
        """
        msg.attach(MIMEText(corpo_email, "html"))

        # Adiciona o arquivo PDF como anexo
        arquivo_pdf_data = await arquivo_pdf.read()
        part_pdf = MIMEApplication(arquivo_pdf_data, Name=arquivo_pdf.filename)
        part_pdf.add_header(
            "Content-Disposition", "attachment", filename=arquivo_pdf.filename
        )
        msg.attach(part_pdf)

        # Adiciona o arquivo Excel como anexo
        arquivo_excel_data = await arquivo_excel.read()
        part_excel = MIMEApplication(arquivo_excel_data, Name=arquivo_excel.filename)
        part_excel.add_header(
            "Content-Disposition", "attachment", filename=arquivo_excel.filename
        )
        msg.attach(part_excel)

        # Envia o e-mail
        with SMTP("smtp.gmail.com", 587) as server:
            server.starttls()
            server.login(remetente, senha)
            server.send_message(msg)

        return JSONResponse(
            content={"message": f"E-mail enviado para {destinatario} com sucesso!"},
            status_code=200,
        )
    except Exception as e:
        print("Erro ao enviar e-mail:", e)  # Adicionando um log para capturar exceções
        raise HTTPException(status_code=500, detail=f"Erro ao enviar e-mail: {e}")
