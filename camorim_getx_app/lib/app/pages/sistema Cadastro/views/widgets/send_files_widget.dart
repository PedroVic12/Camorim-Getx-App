import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

class GeneratePDF extends StatefulWidget {
  @override
  _GeneratePDFState createState() => _GeneratePDFState();
}

class _GeneratePDFState extends State<GeneratePDF> {
  final _formKey = GlobalKey<FormState>();
  final _dataController = TextEditingController();

  Future<void> _generatePDF() async {
    if (_formKey.currentState!.validate()) {
      final data = json.decode(_dataController.text);

      // Envie os dados para a API
      final response = await http.post(
        Uri.parse('https://docker-raichu.onrender.com/generate-pdf'),
        body: json.encode(data),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Salve o PDF em um arquivo temporário
        final arquivoTemp =
            await File(String.fromCharCodes(response.bodyBytes));
        //final tempFile = await File.fromTemp(response.bodyBytes);

        print(arquivoTemp);

        // Abra o PDF no aplicativo
        await OpenFile.open(arquivoTemp.path);
      } else {
        // Exiba uma mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar PDF. Tente novamente.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _dataController,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: 'Dados da OS (JSON)',
              ),
            ),
            ElevatedButton(
              onPressed: _generatePDF,
              child: Text('Gerar PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
