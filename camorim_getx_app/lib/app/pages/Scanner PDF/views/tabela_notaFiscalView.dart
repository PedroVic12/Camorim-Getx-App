import 'package:camorim_getx_app/app/pages/CRUD%20Excel/controllers/bulbassaur_excel.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/controller/nota_fiscal_controller.dart';
import 'package:camorim_getx_app/widgets/DataGridWidget.dart';
import 'package:camorim_getx_app/widgets/TableCustom.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NotaFiscalView extends StatelessWidget {
  final NotaFiscalController controller;

  const NotaFiscalView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bulbassauro = Get.put(BulbassauroExcelController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dados Cadastrados"),
      ),
      body: Obx(() => ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.dataController,
                        decoration: const InputDecoration(
                          labelText: "Data",
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextField(
                        controller: controller.localController,
                        decoration: const InputDecoration(
                          labelText: "Local",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: controller.produtosController,
                  decoration: const InputDecoration(
                    labelText: "Produtos",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: controller.totalController,
                  decoration: const InputDecoration(
                    labelText: "Total",
                  ),
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => controller.salvarDados(),
                    child: const Text("Salvar Forms"),
                  ),
                  ElevatedButton(
                    onPressed: () => bulbassauro.salvarDadosNotaFiscal(),
                    child: const Text("Salvar Excel"),
                  ),
                ],
              ),

              //const DataTableWidget(columns: ["DATA", "LOCAL", "PRODUTOS", "TOTAL"]),
              showDadosCadastrados(),
              DataJson(),
              //const DataTableWidget(),
            ],
          )),
    );
  }

  Widget DataJson() {
    return DataGridWidget(
      jsonFilePath:
          "lib/app/pages/OCR_PAGE/repository/Nota_fiscal_OCR_template.json",
      columns: ["DATA", "LOCAL", "PRODUTOS", "TOTAL"],
    );
  }

  Widget showDadosCadastrados() {
    
    if (controller.notasFiscais_ARRAY.isEmpty) {
      return const Center(
        child: CustomText(text: 'Sem dados cadastrados DO FORMS'),
      );
    } else {
      return Container(
        height: 400,
        child: ListView.builder(
          itemCount: controller.notasFiscais_ARRAY.length,
          itemBuilder: (context, index) {
            final notaFiscal = controller.notasFiscais_ARRAY[index];
            return Table(
              children: [
                TableRow(
                  children: [
                    Text(notaFiscal.data),
                    Text(notaFiscal.local),
                    Text(notaFiscal.produtos.join(", ")),
                    Text(notaFiscal.total.toString()),
                  ],
                ),
              ],
            );
          },
        ),
      );
    }
  }
}
