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
    return ListView(
      children: [
        AspectRatio(
          aspectRatio: 2,
          child: SizedBox(
            width: double.infinity,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) {
                return InkWell(
                  child: InfoCard(),
                  onTap: () {},
                );
              },
            ),
          ),
        ),
        //ConsultaDadosOS(),
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
