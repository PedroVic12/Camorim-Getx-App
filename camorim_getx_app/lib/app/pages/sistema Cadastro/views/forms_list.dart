import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/cadastro_page.dart';
import 'package:camorim_getx_app/widgets/BotaoWidget.dart';
import 'package:camorim_getx_app/widgets/CaixaDeTexto.dart';
import 'package:camorim_getx_app/widgets/DropMenuForm.dart';
import 'package:camorim_getx_app/widgets/RadioButtonGroup.dart';
import 'package:camorim_getx_app/widgets/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FormsListRelatorioOS extends StatelessWidget {
  FormsListRelatorioOS({super.key});

  final CadastroController relatorio_controller = Get.put(CadastroController());

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: ScrollController(),
      thickness: 12,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: DropMenuForm(
                  labelText: 'REBOCADOR',
                  options: const [
                    'PEROLA',
                    'AÇU',
                    "TOPÁZIO",
                    "ESMERALDA",
                    "TORMENTA",
                    "TORNADO",
                    "ZANGADO",
                    "TEMPESTADE",
                    'ÁGATA',
                    "ANDREIS XI",
                    "ATLÂNTICO"
                  ],
                  textController: relatorio_controller.nomeRebocadorText,
                ),
              ),
              Expanded(
                child: DropMenuForm(
                  labelText: 'OFICINA',
                  options: const [
                    'ELÉTRICA',
                    "MECÂNICA",
                  ],
                  textController: relatorio_controller.oficina,
                ),
              ),
              Expanded(
                child: CaixaDeTexto(
                    controller: relatorio_controller.funcionarios,
                    labelText: 'RESPONSÁVEL PELA EXECUÇÃO'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CaixaDeTexto(
                  controller: relatorio_controller.dataAbertura,
                  labelText: 'DATA ABERTURA',
                  onTap: () async {
                    var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2001),
                      lastDate: DateTime(2030),
                      locale: const Locale('pt',
                          'BR'), // Define o local para Português do Brasil
                    );
                    if (date != null) {
                      // Formata a data para o formato desejado
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(date);
                      // Define o texto do controlador com a data formatada
                      relatorio_controller.dataAbertura.text = formattedDate;
                    }
                  },
                ),
              ),
              Expanded(
                child: DropMenuForm(
                  labelText: 'EQUIPAMENTO',
                  options: const [
                    "ACOMODAÇÕES ",
                    " AMARRAÇÃO E FUNDEIO",
                    "AR CONDICIONADO ",
                    "BOMBAS ",
                    "CASCO ",
                    "COMPRESSOR 1",
                    "COMUNICAÇÃO ",
                    "ELÉTRICA/ELETRÔNICO ",
                    "ELETRODOMÉSTICOS ",
                    "EQUIPAMENTOS DE INCÊNDIO ",
                    "EQUIPAMENTOS NÁUTICOS ",
                    "ESTRUTURA ",
                    "GUINCHO DE POPA",
                    "GUINCHO DE PROA ",
                    "INSTALAÇÕES",
                    "LEME",
                    "LINHA DE EIXO BB",
                    "MCA BB",
                    "MCA BE",
                    "MCA 02"
                    "MCP BB",
                    "MCP BE",
                    "MCP LC",
                    "MCP 02",
                    "MUNK",
                    "PORTAS/ESCOTILHAS",
                    "PROPULSOR BB",
                    "PURIFICADOR",
                    "REDES",
                    "REVERSOR BB",
                    "REVERSOR BE",
                    "REVERSOR LC",
                    "SISTEMA DE BATERIAS",
                    "SISTEMA DE GOVERNO BE",
                    "SISTEMA DE GOVERNO LC",
                    "TANQUES",
                    "VENTILAÇÃO/EXAUSTÃO BB"
                  ],
                  textController: relatorio_controller.EQUIPAMENTO_TEXT,
                ),
              ),
              Expanded(
                child: DropMenuForm(
                  labelText: 'MANUTENÇÃO',
                  options: const [
                    'CORRETIVA',
                    "PREVENTIVA",
                    'MELHORIA',
                  ],
                  textController: relatorio_controller.manutencao,
                ),
              ),
            ],
          ),
          CaixaDeTexto(
              controller: relatorio_controller.descFalha,
              labelText: 'DESCRIÇÃO DA FALHA'),
          CaixaDeTexto(
              controller: relatorio_controller.ACAOTEXT,
              labelText: 'SERVIÇO EXECUTADO'),
          Row(
            children: [
              const TextLabel(texto: 'Serviço Finalizado??'),
              Expanded(
                child: RadioButtonGroup(
                  niveis: relatorio_controller.opcoes,
                  nivelSelecionado: relatorio_controller.nivelSelecionado,
                ),
              ),
              const TextLabel(texto: 'FORA DE OPERAÇÃO'),
              Expanded(
                child: RadioButtonGroup(
                  niveis: relatorio_controller.opcoes,
                  nivelSelecionado: relatorio_controller.optionSelected,
                ),
              ),
              Expanded(
                child: CaixaDeTexto(
                    controller: relatorio_controller.dataConclusao,
                    labelText: 'DATA CONCLUSÃO'),
              ),
            ],
          ),
          CaixaDeTexto(
              controller: relatorio_controller.obs, labelText: 'OBSERVAÇÕES'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BotaoPadrao(
                  on_pressed: () {
                    relatorio_controller.salvar(
                      context,
                    );
                  },
                  color: Colors.green,
                  text: 'Salvar'),
              BotaoPadrao(on_pressed: () {}, color: Colors.red, text: 'Limpar')
            ],
          )
        ],
      ),
    );
  }
}
