import 'package:camorim_getx_app/app/pages/Scanner%20PDF/controller/Ocr_controller_notaFiscal.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/controller/nota_fiscal_controller.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/views/tabela_notaFiscalView.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/views/widget_extrairTexto.dart';
import 'package:camorim_getx_app/widgets/NavBarCustom.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getX;
import 'package:intl/intl.dart';

class ScannerOCRWithBackEND extends StatefulWidget {
  const ScannerOCRWithBackEND({super.key});

  @override
  State<ScannerOCRWithBackEND> createState() => _ScannerOCRWithBackENDState();
}

class _ScannerOCRWithBackENDState extends State<ScannerOCRWithBackEND> {
  final OCRController ocrController = OCRController();
  final NotaFiscalController notaFiscalController = NotaFiscalController();

  @override
  void initState() {
    super.initState();
    ocrController.getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade300,
      appBar: AppBar(title: const Text("OCR App e Backend Server")),
      body: ListView(
        children: [
          Row(
            children: [
              BotaoAcao(
                  texto: 'Escolher Imagem',
                  acao: ocrController.escolherImagemGaleria),
              BotaoAcao(
                  texto: ' Imagem Camera',
                  acao: ocrController.escolherImagemCamera),
              cardButton(ocrController.obterTexto, Icons.sms_failed_rounded,
                  'Obter Texto'),
            ],
          ),
          if (ocrController.imagemSelecionada != null) CardImagem(),
          Column(
            children: [
              cardTextoEditavel("Data", ocrController.dataText),
              cardTextoEditavel("Local", ocrController.localText),
              cardTextoEditavel("Produtos", ocrController.produtosText),
              cardTextoEditavel('Total', ocrController.totalText),
              cardTextoEditavel("Categoria", ocrController.categoriaText),
            ],
          ),
          BotaoAcao(
              texto: "Salvar Excel",
              acao: () {
                String dataFormatada =
                    DateFormat('dd/MM/yyyy').format(DateTime.now());
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ocrController.obterTexto,
        child: const Icon(Icons.textsms),
      ),
      bottomNavigationBar: CustomNavBar(
        navBarItems: [
          NavigationBarItem(
              label: 'OCR',
              iconData: Icons.date_range_outlined,
              onPress: () {
                // Get.to(CalendarioWidget());
              }),
          NavigationBarItem(
              label: 'OS DIGITAL',
              iconData: Icons.search,
              onPress: () {
                getX.Get.to(NotaFiscalView(
                  controller: notaFiscalController,
                ));
              }),
        ],
      ),
    );
  }

  Widget cardButton(function, IconData icone, String texto) {
    return InkWell(
      onTap: function,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 120,
          width: 120,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(icone), CustomText(text: texto)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget CardImagem() {
    setState(() {});
    return Column(
      children: [
        GestureDetector(
          child: CustomText(text: ocrController.imagemSelecionada!.path),
        ),
        Container(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(ocrController.imagemSelecionada!.path),
          ),
        )
      ],
    );
  }

  Widget BotaoAcao(
      {required String texto,
      required VoidCallback acao,
      MaterialStateProperty<Color?>? cor}) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: cor),
        onPressed: acao,
        child: Text(texto),
      ),
    );
  }

  Widget cardTextoEditavel(
      String labelText, TextEditingController _controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Digite algo aqui...',
          border: OutlineInputBorder(),
          label: Text(
            labelText,
            style: const TextStyle(
              color: Colors.purple,
            ),
          ),
        ),
        maxLines: null, // Permite múltiplas linhas
        keyboardType: TextInputType.multiline,
      ),
    );
  }

  Widget CardTexto() {
    return Container(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomText(text: ocrController.textoExtraido),
      ),
    );
  }

  void showMessage(String texto1, String texto2) {
    getX.Get.snackbar(texto1, texto2, snackPosition: getX.SnackPosition.TOP);
  }
}
