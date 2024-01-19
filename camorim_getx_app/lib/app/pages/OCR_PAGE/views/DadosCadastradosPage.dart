import 'package:camorim_getx_app/app/pages/CRUD%20Excel/controllers/bulbassaur_excel.dart';
import 'package:camorim_getx_app/widgets/TableCustom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Scanner PDF/controller/nota_fiscal_controller.dart';

class DadosCadastradosPage extends StatelessWidget {
  final NotaFiscalController controller = Get.put(NotaFiscalController());
  final bulbassauro = Get.put(BulbassauroExcelController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dados Cadastrados"),
      ),
      body: Obx(() => ListView(
            children: [
              // Tabela com os dados cadastrados

              TableCustom(
                columns: const [
                  "CATEGORIA",
                  "DATA",
                  "LOCAL",
                  "PRODUTOS",
                  "TOTAL",
                ],
                rows: controller.notasFiscais_ARRAY.map((notaFiscal) {
                  return [
                    notaFiscal.categoria,
                    notaFiscal.data,
                    notaFiscal.local,
                    notaFiscal.produtos.join(", "),
                    notaFiscal.total.toString(),
                  ];
                }).toList(),
              ),

              ElevatedButton(
                onPressed: () => bulbassauro.salvarDadosNotaFiscal(),
                child: const Text("Exportar Excel"),
              ),
            ],
          )),
    );
  }
}
