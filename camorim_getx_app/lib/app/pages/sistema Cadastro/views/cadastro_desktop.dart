// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:camorim_getx_app/app/controllers/PDF-Controller/relatorio_os_template.dart';
import 'package:camorim_getx_app/app/controllers/imagem%20e%20pdf/pegando_arquivo_page.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/CONSULTA/showTableCadastro.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/cadastro_page.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/consulta_dadosPage.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/forms_list.dart';
import 'package:camorim_getx_app/widgets/AppBarPersonalizada.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../CRUD Excel/controllers/excel_controller.dart';

class SistemaCadastroDesktop extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final ExcelController excel_controller = Get.put(ExcelController());
  final CadastroController relatorio_controller = Get.put(CadastroController());
  final NavigationController navController = Get.put(NavigationController());

  SistemaCadastroDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Obtenha a largura da tela
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBarPersonalizada(
        titulo: 'RELATÓRIO ORDEM DE SERVIÇO',
      ),
      body: Row(
        children: [
          buildDrawerDashboard(context, navController),
          Expanded(
            child: Obx(() {
              if (navController.currentPageIndex.value == 1) {
                return ConsultaDash(); // Primeira página
              } else if (navController.currentPageIndex.value == 0) {
                return Container(
                    color: Colors.blueGrey.shade300,
                    child: FormsListRelatorioOS());
              } else if (navController.currentPageIndex.value == 2) {
                return Container(
                  height: 900,
                  child: ShowTableDadosCadastrados(),
                ); // Terceira página
              } else if (navController.currentPageIndex.value == 3) {
                return PdfViewScreen();
              } else {
                return Container(
                  color: Colors.blueGrey.shade300,
                  child: const Center(
                    child: Text('Página não encontrada'),
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerDashboard(
      BuildContext context, NavigationController navController) {
    List<Widget> pages = [
      ConsultaDash(),
      // Adicione mais widgets conforme necessário
    ];
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            duration: const Duration(seconds: 1),
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
            child: Column(
              children: [
                const Text('Setor de Manutenção e Engenharia'),
              ],
            ),
          ),
          ListView.builder(
            // Especifique a quantidade de itens
            itemCount: 5,
            // Necessário para evitar conflitos de scroll com o ListView pai
            shrinkWrap: true,
            // Desativa o scrolling do ListView.builder
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var title = "";
              switch (index) {
                case 0:
                  title = "Cadastro";
                  break;
                case 1:
                  title = "Consulta";
                  break;
                case 2:
                  title = "Relatório";
                  break;
              }
              return ListTile(
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text(
                  'Página $index - $title',
                  style: TextStyle(
                    // Se o índice da página atual for igual ao índice do item, use vermelho; caso contrário, preto.
                    color: navController.currentPageIndex.value == index
                        ? Colors.red
                        : Colors.black,
                  ),
                ),
                onTap: () {
                  navController
                      .changePage(index); // Muda a página usando o controlador
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget relatorioCadastro() {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        PegandoArquivosPage(),
        Obx(() {
          final model = relatorio_controller.currentModel.value;
          final models = relatorio_controller.array_cadastro;
          if (model != null) {
            return Column(
              children: models
                  .map((element) => Card(
                      color: Colors.lightBlue,
                      child: ListTile(
                        title: Text(element.equipamento),
                        subtitle: Column(
                          children: [
                            Text(
                              element.rebocador,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              element.descFalha,
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            models.remove(element);
                          },
                        ),
                      )))
                  .toList(),
            );
          } else {
            return const Text('Sem dados cadastrados :(');
          }
        }),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue,
      child: ListTile(
        title: Text('Equipamento'),
        subtitle: Column(
          children: [
            Text('Rebocador'),
            Text('Ação'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {},
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  var currentPageIndex = 0.obs;

  void changePage(int index) {
    currentPageIndex.value = index;
  }
}
