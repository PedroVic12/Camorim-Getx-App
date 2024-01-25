//import 'package:camorim_getx_app/pages/Scanner%20PDF/CamScannerPage.txt';
import 'package:camorim_getx_app/app/pages/CRUD%20Excel/view/crud_excel_page.dart';
import 'package:camorim_getx_app/app/pages/Controle%20Dique/ControleDiquePage.dart';
import 'package:camorim_getx_app/app/pages/Controlle%20Ferramentas/ControleFerramentas.dart';
import 'package:camorim_getx_app/app/pages/Relatorio%20OS/RelatoriosPage.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/ScannerOcrImgPdfPage.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/views/widget_extrairTexto.dart';
import 'package:camorim_getx_app/widgets/AppBarPersonalizada.dart';
import 'package:camorim_getx_app/widgets/TextLabel.dart';
import 'package:camorim_getx_app/widgets/google_maps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List imagesSrc = ['path_to_images'];

  List titulos = [
    'Ordem de Serviço',
    'Ferramentas',
    'Nota Fiscal OCR',
    'Scanner PDF',
    'Manutenção Dique',
    'CRUD Excel'
  ];

  @override
  Widget build(BuildContext context) {
    final height_screen = MediaQuery.of(context).size.height + 300;
    final width_screen = MediaQuery.of(context).size.width;
    double fontePagina = 8.0;

    // 1. Obtenha a largura da tela
    double screenWidth = MediaQuery.of(context).size.width;

    // 2. Defina uma variável que determinará o número de itens no crossAxisCount com base na largura da tela
    int columns;
    if (screenWidth > 600) {
      columns = 5;
    } else {
      columns = 2;
      fontePagina = 4;
    }
    return Scaffold(
      appBar: AppBarPersonalizada(
        titulo: "HomePage",
      ),
      body: Container(
        color: Colors.red,
        height: height_screen,
        width: width_screen,
        child: ListView(scrollDirection: Axis.vertical, children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
            height: height_screen * 0.15,
            width: width_screen,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Get.to(PedidoTrackingMapsScreen());
                            },
                            child: const Icon(
                              Icons.sort,
                              color: Colors.white,
                              size: 36,
                            )),
                        const ClipRRect(
                          //child: Image.asset('images/camorim_logo.png',
                          child: Icon(Icons.add_a_photo),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const TextLabel(
                            texto: 'Setor de Manutenção e Engenharia',
                            cor: Colors.white),
                        const SizedBox(height: 10),
                        Text(
                          'Ultima atualização: ${DateTime.now()}',
                          style: const TextStyle(
                            color: Colors.white54,
                            letterSpacing: 1,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
          ),
          Container(
            height: height_screen * 0.75,
            width: width_screen,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: titulos.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                childAspectRatio: 1.2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  if (index == 0) {
                    Get.to(RelatorioPage());
                  }

                  if (index == 1) {
                    Get.to(const ControleFerramentasPage());
                  }
                  if (index == 2) {
                    Get.toNamed('/OcrPage');
                  }
                  if (index == 3) {
                    Get.to(ScannerOcrPage());
                  }

                  if (index == 4) {
                    Get.to(ControleDiquePage());
                  }

                  if (index == 5) {
                    Get.to(ContactForm());
                  }
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black, spreadRadius: 1, blurRadius: 6)
                      ]),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 10),
                        TextLabel(
                          texto: titulos[index],
                          size: 3,
                          cor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
