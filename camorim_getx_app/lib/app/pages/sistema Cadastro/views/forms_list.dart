import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/cadastro_page.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/widgets/datetime_picker.dart';
import 'package:camorim_getx_app/widgets/BotaoWidget.dart';
import 'package:camorim_getx_app/widgets/CaixaDeTexto.dart';
import 'package:camorim_getx_app/widgets/DropMenuForm.dart';
import 'package:camorim_getx_app/widgets/DropdownWidget.dart';
import 'package:camorim_getx_app/widgets/RadioButtonGroup.dart';
import 'package:camorim_getx_app/widgets/TextLabel.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FormsListRelatorioOS extends StatelessWidget {
  FormsListRelatorioOS({super.key});

  final CadastroController relatorio_controller = Get.put(CadastroController());
  void _handleIntervalSelected(DateTime start, DateTime end) {
    // Aqui você pode usar o intervalo de horário selecionado, por exemplo:
    print('Intervalo selecionado: de $start até $end');
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: ScrollController(),
      thickness: 12,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          cardinfo("ITENS OBRIGATORIOS"),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: DropMenuForm(
                  labelText: 'REBOCADOR',
                  options: const [
                    'AÇU',
                    "ATLÂNTICO",
                    'ÁGATA',
                    "ALDEBARAN",
                    "ALTAIR",
                    "ANDREIS XI",
                    "ANGRA",
                    "ANTARES",
                    "ARIES",
                    "ARRAIAL",
                    "ARTHUR",
                    "BALSA CAMORIM",
                    "BALSA DIALCAR",
                    "BALSA EQUIP 110",
                    "BALSA EQUIP 190",
                    "EQUIP 180",
                    "BRILHANTE",
                    "CAMORIM XVII",
                    "CARAJAS",
                    "CARLA",
                    "CETUS",
                    "CICLONE",
                    "COBRE",
                    "CRISTAL",
                    "DIAMANTE",
                    "MERLIM",
                    "DIAlCAR III",
                    "EMBARCAÇÃO LOT",
                    "ESMERALDA",
                    "FELIZ",
                    "FLORA",
                    "ITACURUÇA",
                    "JADE",
                    "LANCHA ALUMINA III",
                    "LANCHA JAF",
                    "LANCHA OCEANBOAT ",
                    "LANCHA SAVEIROS TOUR I",
                    "LANCHA ST. TROPEZ",
                    "LANCHA YECA",
                    "LH COMANDANTE",
                    "MACAE",
                    "MACEIO",
                    "MERCURIO IV",
                    "MINI OR",
                    "MINIBOLA",
                    "N ALMEIDA VII",
                    "NAVEMAR XIV",
                    "NEBLINA",
                    "NEVOEIRO",
                    "NEW FURACÃO",
                    "NEW TROVÃO",
                    "NIQUEL",
                    "NITEROI",
                    "OPALA",
                    "ORION",
                    "OURO",
                    "PEGASUS",
                    "PEROLA",
                    "PERSIVAL",
                    "PRUDENT",
                    "QUARTZO",
                    "REBOC-CERRAÇÃO(ANT TEXAS)",
                    "RELAMPAGO",
                    "RIO",
                    "SAGA RONCADOR",
                    "SAGAMORIM II",
                    "SAGITARIUS",
                    "SALVADOR",
                    "SEPETIBA",
                    "SIRIUS",
                    "SUPERPESA XIII",
                    "SUPERPESA XIV",
                    "TITA",
                    "TEMPESTADE",
                    "TEMPORAL",
                    "TOPÁZIO",
                    "TORMENTA",
                    "TORNADO",
                    "TRINDADE",
                    "TUFAO",
                    "TURMALINA",
                    "TURQUEZA",
                    "VENDAVAL",
                    "VENTANIA",
                    "VIGO MAXIMUS",
                    "VITORIA",
                    "ZANGADO",
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
                    "MCA 02",
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
              Expanded(
                child: RadioButtonGroup(
                  textLabel: "Serviço Finalizado?",
                  niveis: relatorio_controller.opcoes,
                  nivelSelecionado: relatorio_controller.nivelSelecionado,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: RadioButtonGroup(
                  textLabel: "FORA DE OPERAÇÃO",
                  niveis: relatorio_controller.opcoes,
                  nivelSelecionado: relatorio_controller.optionSelected,
                ),
              ),
            ],
          ),
          Expanded(
            child: CaixaDeTexto(
                controller: relatorio_controller.dataConclusao,
                labelText: 'DATA CONCLUSÃO'),
          ),
          CaixaDeTexto(
              controller: relatorio_controller.obs, labelText: 'OBSERVAÇÕES'),
          cardinfo("Itens Opcionais"),
          Expanded(
            child: TimeRangePickerWidget(
              onIntervalSelected: (TimeOfDay start, TimeOfDay end) {
                TimeOfDay roomBooked = TimeOfDay.fromDateTime(DateTime.parse(
                    '2021-10-10 ${start.hour}:${start.minute}:00Z'));

                print('Intervalo selecionado: de $start até $end');
                relatorio_controller.horarios.text = roomBooked.toString();
              },
            ),
          ),
          Expanded(
            child: CaixaDeTexto(
              onTap: () {},
              controller: relatorio_controller.horarios,
              labelText: "Horários",
            ),
          ),
          inserirFotoOuArquivo(),
          btnsRows(context)
        ],
      ),
    );
  }

  Widget btnsRows(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Obx(() {
          if (relatorio_controller.contadorServices >= 0) {
            return BotaoPadrao(
                on_pressed: () {
                  relatorio_controller.salvarDadosCadastradosRelatorio(
                    context,
                  );

                  relatorio_controller.descFalha.clear();
                  relatorio_controller.ACAOTEXT.clear();
                  relatorio_controller.obs.clear();
                  relatorio_controller.servicoFinalizado.value = false;
                  relatorio_controller.dataConclusao.clear();

                  relatorio_controller.contadorServices++;
                },
                color: Colors.blue,
                text:
                    'Adicionar mais dados - ($relatorio_controller.contadorServices)');
          }

          return BotaoPadrao(
              on_pressed: () {
                relatorio_controller.salvarDadosCadastradosRelatorio(
                  context,
                );

                print(
                    "Ultimo item cadastroado = ${relatorio_controller.array_cadastro.last} ");

                for (var i;
                    i < relatorio_controller.array_cadastro.length;
                    i++) {
                  print("Item $i = ${relatorio_controller.array_cadastro[i]}");
                }

                relatorio_controller.descFalha.clear();
                relatorio_controller.ACAOTEXT.clear();
                relatorio_controller.obs.clear();
                relatorio_controller.servicoFinalizado.value = false;
                relatorio_controller.dataConclusao.clear();

                relatorio_controller.contadorServices++;
              },
              color: Colors.blue,
              text: 'Adicionar mais dados');
        }),
        BotaoPadrao(
            on_pressed: () {
              relatorio_controller.salvarDadosCadastradosRelatorio(
                context,
              );
              relatorio_controller.resetLabels();
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
    );
  }

  Widget inserirFotoOuArquivo() {
    return Container(
      color: Colors.amberAccent,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          const TextLabel(
            texto: 'Inserir Foto ou Arquivo',
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Inserir Foto'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Inserir Arquivo'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cardinfo(txt) {
    return Card(
      color: Colors.redAccent.shade400,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            CustomText(
              text: txt,
              size: 20,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
