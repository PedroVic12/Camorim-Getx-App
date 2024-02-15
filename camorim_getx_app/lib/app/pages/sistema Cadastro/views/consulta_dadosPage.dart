import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/cadastro_desktop.dart';
import 'package:camorim_getx_app/widgets/NavBarCustom.dart';
import 'package:camorim_getx_app/widgets/TableCustom.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../CRUD Excel/controllers/bulbassaur_excel.dart';

class ConsultaDash extends StatelessWidget {
  const ConsultaDash({super.key});

  @override
  Widget build(BuildContext context) {
    final CadastroController relatorio_controller =
        Get.find<CadastroController>();

    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        AspectRatio(
          aspectRatio: 3,
          child: SizedBox(
            width: double.infinity,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemBuilder: (context, index) {
                return InfoCard();
              },
            ),
          ),
        ),
        ConsultaDadosOS(),
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

class ConsultaDadosOS extends StatelessWidget {
  final bulbassauro = Get.put(BulbassauroExcelController());
  final CadastroController relatorio_controller = Get.put(CadastroController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            // Tabela com os dados cadastrados

            TableCustom(
              columns: const [
                "EMBARCAÇÃO",
                "CATEGORIA",
                "DATA",
              ],
              rows: relatorio_controller.array_cadastro.map((data) {
                return [
                  data.equipamento,
                  data.rebocador,
                  data.dataInicial,
                ];
              }).toList(),
            ),

            ElevatedButton(
              onPressed: () => bulbassauro.salvarDadosNotaFiscal(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.indigo),
              ),
              child: const CustomText(
                text: "Exportar Excel",
                color: Colors.white,
              ),
            ),
          ],
        ));
  }
}
