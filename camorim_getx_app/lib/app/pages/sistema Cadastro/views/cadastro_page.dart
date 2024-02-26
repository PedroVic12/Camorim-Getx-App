// ignore_for_file: non_constant_identifier_names

import 'package:camorim_getx_app/app/controllers/imagem%20e%20pdf/pegando_arquivo_page.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/cadastro_desktop.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/forms_list.dart';
import 'package:camorim_getx_app/widgets/BotaoWidget.dart';
import 'package:camorim_getx_app/widgets/CustomCheckBox.dart';
import 'package:camorim_getx_app/widgets/DropMenuForm.dart';
import 'package:camorim_getx_app/widgets/NavBarCustom.dart';
import 'package:camorim_getx_app/widgets/RadioButtonGroup.dart';
import 'package:camorim_getx_app/widgets/TextLabel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/AppBarPersonalizada.dart';
import '../../../../widgets/CaixaDeTexto.dart';
import '../../CRUD Excel/controllers/excel_controller.dart';
import '../cadastro_controllers.dart';

//TODO -> LER FOTO DO DOCUMENTO
//TODO ->  EXTRAIR INFORMACOES
//TODO -> CADASTRO NO SISTEMA E NO EXCEL ONLINE
//TODO -> GERAR RELATORIO PDF DIGITAL (EQUIPAMENTO-REBOCADOR-DATA)
//TODO -> ENVIAR RELATORIO POR EMAIL COM DATA DE ENVIO

class SistemaCadastroPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final ExcelController excel_controller = Get.put(ExcelController());
  final CadastroController relatorio_controller = Get.put(CadastroController());

  SistemaCadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizada(
        titulo: 'RELATÓRIO ORDEM DE SERVIÇO - MOBILE',
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          FormsListRelatorioOS(),
          //showTableDadosCadastrados(context)
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        navBarItems: [
          NavigationBarItem(
              label: 'Cadastro',
              iconData: Icons.date_range_outlined,
              onPress: () {
                // Get.to(CalendarioWidget());
              }),
          NavigationBarItem(
              label: 'TELA CONSULTA',
              iconData: Icons.search,
              onPress: () {
                Get.to(SistemaCadastroDesktop());
              }),
        ],
      ),
    );
  }

  Widget showTableDadosCadastrados(context) {
    return Column(
      children: [
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
                              element.dataInicial,
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BotaoPadrao(
                on_pressed: () {
                  relatorio_controller.salvar(
                    context,
                  );
                },
                color: Colors.green,
                text: 'Salvar'),
            BotaoPadrao(
                on_pressed: () {
                  relatorio_controller.resetLabels();
                },
                color: Colors.red,
                text: 'Limpar')
          ],
        )
      ],
    );
  }
}
