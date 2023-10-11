import 'package:camorim_getx_app/app/controllers/relatorios/RelatorioController.dart';
import 'package:camorim_getx_app/app/pages/CRUD%20Excel/controllers/excel_controller.dart';
import 'package:camorim_getx_app/app/pages/CRUD%20Excel/model/contact_model.dart';
import 'package:camorim_getx_app/app/pages/Relatorio%20OS/models/RelatorioModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/relatorios_widgets.dart';

class RelatorioPage extends StatelessWidget {
  final RelatorioController relatorio_controller =
      Get.put(RelatorioController());
  final _formKey = GlobalKey<FormState>();
  final ExcelController excel_controller = Get.put(ExcelController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatorios Page'),
        foregroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            DisplaySimpleForms(),
            DisplayFormsResults(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Adicione ou atualize o contato usando o ContactController
            //final contact = Relatorio(               descricaoFalha:                );
            //excel_controller.addContact(contact as Contact);
            Get.back();
          }
        },
        child: Text('Save'),
      ),
    );
  }
}
