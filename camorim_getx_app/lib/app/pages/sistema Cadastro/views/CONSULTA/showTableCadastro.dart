import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:camorim_getx_app/widgets/TableCustom.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../CRUD Excel/controllers/bulbassaur_excel.dart';

class ShowTableDadosCadastrados extends StatelessWidget {
  final bulbassauro = Get.put(BulbassauroExcelController());
  final CadastroController relatorio_controller = Get.put(CadastroController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(
          scrollDirection: Axis.vertical,
          children: [
            // Tabela com os dados cadastrados
            CustomText(
                text: "Dados Cadastrados", size: 32, color: Colors.black),

            TableCustom(
              columns: const [
                "EMBARCAÇÃO",
                "DESCRIÇÃO DA FALHA",
                "EQUIPAMENTO",
                "MANUTENÇÃO",
                "SERVIÇO EXECUTADO",
                "DATA DE ABERTURA",
                "RESPONSAVEL EXECUÇÃO",
                "OFICINA",
                "FINALIZADO",
                "DATA DE CONCLUSÃO",
                "FORA DE OPERAÇÃO",
                "OBSERVAÇÃO",
              ],
              rows: relatorio_controller.array_cadastro.map((data) {
                return [
                  data.rebocador,
                  data.descFalha,
                  data.equipamento,
                  data.tipoManutencao,
                  data.servicoExecutado,
                  data.dataFinal.toString(),
                  data.funcionario.toString(),
                  data.oficina,
                  data.status_finalizado.toString(),
                  data.dataFinal.toString(),
                  data.status_finalizado.toString(),
                  data.obs
                ];
              }).toList(),
            ),

            ElevatedButton(
              onPressed: () => bulbassauro.salvarDadosRelatorioOS(),
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
