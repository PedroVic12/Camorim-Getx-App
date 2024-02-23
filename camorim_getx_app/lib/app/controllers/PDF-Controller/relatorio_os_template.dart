import 'dart:convert';
import 'dart:io';
import 'package:camorim_getx_app/widgets/TableCustom.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:universal_html/html.dart' as html;

import '../../pages/sistema Cadastro/cadastro_controllers.dart';

class PdfViewScreen extends StatelessWidget {
  const PdfViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CadastroController relatorio_controller =
        Get.put(CadastroController());

    void getData() {
      var dados = relatorio_controller.array_cadastro.map((data) {
        return [
          data.rebocador,
          data.descFalha,
          data.equipamento,
          data.tipoManutencao,
          data.servicoExecutado,
          data.dataFinal.toString(),
          data.funcionario.toString(),
          data.oficina,
          data.status_finalizado.toString(),
          data.dataFinal.toString(),
          data.status_finalizado.toString(),
          data.obs
        ];
      }).toList();
      print("\nDados = $dados");
    }

    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        ElevatedButton(
            onPressed: () {
              loadPdfFromAssets();
            },
            child: Text("Gerar PDF")),
        Container(
          height: 600,
          child: SfPdfViewer.asset("./assets/RELAToRIO_ORDEMSERVICO.pdf"),
        ),
        Obx(() => TableCustom(
              columns: const [
                "EMBARCAÇÃO",
                "DESCRIÇÃO DA FALHA",
                "EQUIPAMENTO",
                "MANUTENÇÃO",
                "SERVIÇO EXECUTADO",
                "DATA DE ABERTURA",
                "RESPONSAVEL EXECUÇÃO",
                "OFICINA",
                "FINALIZADO",
                "DATA DE CONCLUSÃO",
                "FORA DE OPERAÇÃO",
                "OBSERVAÇÃO",
              ],
              rows: relatorio_controller.array_cadastro.map((data) {
                return [
                  data.rebocador,
                  data.descFalha,
                  data.equipamento,
                  data.tipoManutencao,
                  data.servicoExecutado,
                  data.dataFinal.toString(),
                  data.funcionario.toString(),
                  data.oficina,
                  data.status_finalizado.toString(),
                  data.dataFinal.toString(),
                  data.status_finalizado.toString(),
                  data.obs
                ];
              }).toList(),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                createAndDownloadPdf();
              },
              child: Text("Hello World")),
        ),
        ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );

            if (result != null) {
              Uint8List fileBytes = result.files.first.bytes!;
              String fileName = result.files.first.name;

              // Aqui você pode usar os bytes do arquivo PDF conforme necessário
              // Por exemplo, carregando o PDF no PdfDocument para manipulação
              final PdfDocument document = PdfDocument(inputBytes: fileBytes);
              loadPdf(document);

              // Fazer algo com o documento, como ler ou modificar

              // Mostrar uma mensagem ou realizar uma ação com o arquivo
              print('PDF carregado: $fileName');
            } else {
              // O usuário cancelou a seleção do arquivo
            }
          },
          child: Text('Selecionar PDF'),
        ),
      ],
    );
  }

  Future<void> saveAndLaunchFile(bytes, fileName) async {
    html.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", fileName)
      ..click();
  }

  void abrirPdf() {
    SfPdfViewer.asset("./assets/RELATÓRIO DE ORDEM DE SERVIÇO - REVISÃO.pdf");
  }

  Future<void> loadPdfFromAssets() async {
    final ByteData data = await rootBundle
        .load("./assets/RELATÓRIO DE ORDEM DE SERVIÇO - REVISÃO.pdf");
    final Uint8List bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    final PdfDocument document = PdfDocument(inputBytes: bytes);
    modifyPdf(document);
  }

  void createAndDownloadPdf() async {
    final PdfDocument document = PdfDocument();
    // Adiciona uma página ao PDF e desenha algo, por exemplo.
    document.pages.add().graphics.drawString(
        'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: const Rect.fromLTWH(0, 0, 150, 20));

    // Salvando o PDF gerado para download.
    final List<int> bytes = await document.save();

    // Chamada para salvar e iniciar o download do arquivo.
    saveAndLaunchFile(bytes, 'generatedPdf.pdf');

    document.dispose();
  }

  // Função adaptada para Flutter Web
  void selectAndModifyPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      // Carrega o PDF no PdfDocument para manipulação
      final PdfDocument document = PdfDocument(inputBytes: fileBytes);
      modifyPdf(document);
      // Outras manipulações...
    } else {
      // O usuário cancelou a seleção do arquivo
      print('Nenhum arquivo selecionado');
    }
  }

  void modifyPdf(PdfDocument document) async {
    // Modifica o documento PDF como necessário
    document.pages[0].annotations.add(PdfRectangleAnnotation(
        Rect.fromLTWH(0, 0, 150, 100), 'Rectangle',
        color: PdfColor(255, 0, 0), setAppearance: true));

    document.pages.add().graphics.drawString(
        'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: const Rect.fromLTWH(0, 0, 150, 20));

    // Salvando o PDF gerado para download.
    final List<int> bytes = await document.save();

    // Usa a função saveAndLaunchFile para iniciar o download do arquivo modificado
    saveAndLaunchFile(bytes, 'modifiedPdf.pdf');

    document.dispose();
  }

  void loadPdf(PdfDocument document) async {
//Create a new rectangle annotation and add to the PDF page.
    document.pages[0].annotations.add(PdfRectangleAnnotation(
        Rect.fromLTWH(0, 0, 150, 100), 'Rectangle',
        color: PdfColor(255, 0, 0), setAppearance: true));

    document.pages.add().graphics.drawString(
        'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: const Rect.fromLTWH(0, 0, 150, 20));

    // Salvando o PDF gerado para download.
    final List<int> bytes = await document.save();

    // Chamada para salvar e iniciar o download do arquivo.
    saveAndLaunchFile(bytes, 'generatedPdf.pdf');

    document.dispose();
  }

  void addListas() async {
    // Create a new PDF document.
    final PdfDocument document = PdfDocument();
// Add a new page to the document.
    final PdfPage page = document.pages.add();
// Create a PDF ordered list.
    final PdfOrderedList orderedList = PdfOrderedList(
        items: PdfListItemCollection(<String>[
          'Mammals',
          'Reptiles',
          'Birds',
          'Insects',
          'Aquatic Animals'
        ]),
        marker: PdfOrderedMarker(
            style: PdfNumberStyle.numeric,
            font: PdfStandardFont(PdfFontFamily.helvetica, 12)),
        markerHierarchy: true,
        format: PdfStringFormat(lineSpacing: 10),
        textIndent: 10);
// Create a un ordered list and add it as a sublist.
    orderedList.items[0].subList = PdfUnorderedList(
        marker: PdfUnorderedMarker(
            font: PdfStandardFont(PdfFontFamily.helvetica, 10),
            style: PdfUnorderedMarkerStyle.disk),
        items: PdfListItemCollection(<String>[
          'body covered by hair or fur',
          'warm-blooded',
          'have a backbone',
          'produce milk',
          'Examples'
        ]),
        textIndent: 10,
        indent: 20);
// Draw the list to the PDF page.
    orderedList.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height));
// Save the document.
    var bytes = document.save();
    saveAndLaunchFile(bytes, "output.pdf");
// Dispose the document.
    document.dispose();
  }
}
