import 'package:camorim_getx_app/app/pages/Scanner%20PDF/views/widget_extrairTexto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScannerOCRWithBackEND extends StatefulWidget {
  const ScannerOCRWithBackEND({super.key});

  @override
  State<ScannerOCRWithBackEND> createState() => _ScannerOCRWithBackENDState();
}

class _ScannerOCRWithBackENDState extends State<ScannerOCRWithBackEND> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OCR Page 2 ")),
      body: ListView(
        children: [
          WidgetSelecionadorImagem(),
        ],
      ),
    );
  }
}
