import 'package:camorim_getx_app/pages/CamScannerPage.dart';
import 'package:camorim_getx_app/pages/ControleFerramentas.dart';
import 'package:camorim_getx_app/pages/RelatoriosPage.dart';
import 'package:camorim_getx_app/widgets/TextLabel.dart';
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
    'Scanner PDF',
    'Monitoramento'
  ];

  @override
  Widget build(BuildContext context) {
    final height_screen = MediaQuery.of(context).size.height;
    final width_screen = MediaQuery.of(context).size.width;

    // 1. Obtenha a largura da tela
    double screenWidth = MediaQuery.of(context).size.width;

    // 2. Defina uma variável que determinará o número de itens no crossAxisCount com base na largura da tela
    int columns;
    if (screenWidth > 600) {
      columns = 4;
    } else {
      columns = 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('HomePage')),
        backgroundColor: Colors.red,
      ),
      body: Container(
        color: Colors.indigo,
        height: height_screen,
        width: width_screen,
        child: ListView(children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.indigo,
            ),
            height: height_screen * 0.30,
            width: width_screen,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 35, left: 15, right: 15),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Get.to(RelatorioPage());
                        },
                        child: const Icon(
                          Icons.sort,
                          color: Colors.white,
                          size: 40,
                        )),
                    const ClipRRect(
                      //child: Image.asset('images/camorim_logo.png',
                      child: Icon(Icons.add_a_photo),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextLabel(texto: 'Dashboard', cor: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      'Ultima atualização: ',
                      style: TextStyle(
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
                mainAxisSpacing: 20,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  if (index == 0) {
                    Get.to(RelatorioPage());
                  }

                  if (index == 1) {
                    Get.to(ControleFerramentasPage());
                  }
                  if (index == 2) {
                    // O índice 2 corresponde ao item 'Scanner PDF' no seu array
                    Get.to(CamScannerPage());
                  } else {
                    // Outras ações quando outros itens forem clicados
                  }
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        const BoxShadow(
                            color: Colors.black, spreadRadius: 1, blurRadius: 6)
                      ]),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(height: 10),
                        TextLabel(
                          texto: titulos[index],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const CamScannerPage());
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}
