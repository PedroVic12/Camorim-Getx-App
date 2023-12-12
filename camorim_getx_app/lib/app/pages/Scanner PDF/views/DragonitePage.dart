import 'package:camorim_getx_app/app/pages/Scanner%20PDF/models/Dragonite.dart';
import 'package:flutter/material.dart';

class PdfGeneratorPage extends StatefulWidget {
  @override
  _PdfGeneratorPageState createState() => _PdfGeneratorPageState();
}

class _PdfGeneratorPageState extends State<PdfGeneratorPage> {
  final DragonitePDF dragonitePDF = DragonitePDF();
  String message = '';

  void _createSimpleTextPDF() async {
    String filePath = await dragonitePDF.createSimpleTextPDF(
        'Hello World!', 'simple_text.pdf');
    setState(() {
      message = 'PDF Simples criado: $filePath';
    });
  }

  void _createTrueTypeFontPDF() async {
    String filePath = await dragonitePDF.createTrueTypeFontPDF(
        'Hello World with TrueType Font!',
        'path/to/your/font.ttf', // Caminho para o arquivo da fonte
        'truetype_font.pdf');
    setState(() {
      message = 'PDF com TrueType Font criado: $filePath';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerador de PDF'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _createSimpleTextPDF,
              child: Text('Criar PDF Simples'),
            ),
            ElevatedButton(
              onPressed: _createTrueTypeFontPDF,
              child: Text('Criar PDF com TrueType Font'),
            ),
            SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}
