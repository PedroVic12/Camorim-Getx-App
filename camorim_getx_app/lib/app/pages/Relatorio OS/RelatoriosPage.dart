// ignore_for_file: non_constant_identifier_names

import 'package:camorim_getx_app/app/controllers/imagem%20e%20pdf/pegando_arquivo_page.dart';
import 'package:camorim_getx_app/app/controllers/relatorios/RelatorioController.dart';
import 'package:camorim_getx_app/app/pages/CRUD%20Excel/controllers/excel_controller.dart';
import 'package:camorim_getx_app/app/pages/CRUD%20Excel/model/contact_model.dart';
import 'package:camorim_getx_app/app/pages/Relatorio%20OS/models/RelatorioModel.dart';
import 'package:camorim_getx_app/app/pages/Relatorio%20OS/views/SimpleFormPage.dart';
import 'package:camorim_getx_app/widgets/AppBarPersonalizada.dart';
import 'package:camorim_getx_app/widgets/CaixaDeTexto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/relatorios_widgets.dart';

class RelatorioPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final ExcelController excel_controller = Get.put(ExcelController());

  RelatorioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizada(
        titulo: 'Relatorios OS Page',
      ),
      body: ListView(
        children: [
          FormsListRelatorio(),
          Column(
            children: [
              PegandoArquivosPage(),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text('Save'),
      ),
    );
  }
}

class FormsListRelatorio extends StatelessWidget {
  final RelatorioController relatorio_controller =
      Get.put(RelatorioController());
  FormsListRelatorio({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CaixaDeTexto(
            controller: relatorio_controller.nomeRebocadorText,
            labelText: 'Nome do Rebocador'),
        CaixaDeTexto(
            controller: relatorio_controller.nomeRebocadorText,
            labelText: 'DATA DE ABERTURA'),
        CaixaDeTexto(
            controller: relatorio_controller.nomeRebocadorText,
            labelText: 'EQUIPAMENTO'),
        CaixaDeTexto(
            controller: relatorio_controller.nomeRebocadorText,
            labelText: 'SERVIÇO EXECUTADO'),
        CaixaDeTexto(
            controller: relatorio_controller.nomeRebocadorText,
            labelText: 'FUNCIONÁRIOS RESPONSÁVEIS'),
        CaixaDeTexto(
            controller: relatorio_controller.nomeRebocadorText,
            labelText: 'OFICINA'),
        CaixaDeTexto(
            controller: relatorio_controller.nomeRebocadorText,
            labelText: 'FINALIZADO'),
        CaixaDeTexto(
            controller: relatorio_controller.nomeRebocadorText,
            labelText: 'DATA DE CONCLUSÃO'),
        CaixaDeTexto(
            controller: relatorio_controller.nomeRebocadorText,
            labelText: 'OBS'),
      ],
    );
  }
}
