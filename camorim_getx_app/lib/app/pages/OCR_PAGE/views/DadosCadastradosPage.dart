import 'package:camorim_getx_app/widgets/TableCustom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Scanner PDF/controller/nota_fiscal_controller.dart';

class DadosCadastradosPage extends StatelessWidget {
  final NotaFiscalController controller = Get.put(NotaFiscalController());

  @override
  Widget build(BuildContext context) {
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
                ],
              ),

              // Tabela com os dados cadastrados

              TableCustom(
                columns: const [
                  "DATA",
                  "LOCAL",
                  "PRODUTOS",
                  "TOTAL",
                ],
                rows: controller.notasFiscais_ARRAY.map((notaFiscal) {
                  return [
                    notaFiscal.data,
                    notaFiscal.local,
                    notaFiscal.produtos.join(", "),
                    notaFiscal.total.toString(),
                  ];
                }).toList(),
              ),
            ],
          )),
    );
  }
}
