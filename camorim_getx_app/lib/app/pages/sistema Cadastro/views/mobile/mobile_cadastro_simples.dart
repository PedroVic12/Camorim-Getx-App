import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/CONSULTA/showTableCadastro.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/forms_list.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/mobile/views/DatabasePage.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/mobile/views/consulta_grid.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/mobile/views/dados_mongo_dart_mobile.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/widgets/datetime_picker.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/widgets/galeria_fotos_array.dart';
import 'package:camorim_getx_app/widgets/BotaoWidget.dart';
import 'package:camorim_getx_app/widgets/CaixaDeTexto.dart';
import 'package:camorim_getx_app/widgets/DropMenuForm.dart';
import 'package:camorim_getx_app/widgets/FabMenuButton.dart';
import 'package:camorim_getx_app/widgets/NavBarCustom.dart';
import 'package:camorim_getx_app/widgets/RadioButtonGroup.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:camorim_getx_app/widgets/glass_card_container.dart';
import 'package:camorim_getx_app/widgets/table_excel_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// TODO -> Tensão, funções, atuadores, VB, TORREs

class MobileCadastroSimplesRelatorioDigital extends StatefulWidget {
  const MobileCadastroSimplesRelatorioDigital({super.key});

  @override
  State<MobileCadastroSimplesRelatorioDigital> createState() =>
      _MobileCadastroSimplesRelatorioDigitalState();
}

class _MobileCadastroSimplesRelatorioDigitalState
    extends State<MobileCadastroSimplesRelatorioDigital> {
  @override
  Widget build(BuildContext context) {
    final CadastroController relatorio_controller =
        Get.put(CadastroController());
    void _handleIntervalSelected(DateTime start, DateTime end) {
      // Aqui você pode usar o intervalo de horário selecionado, por exemplo:
      print('Intervalo selecionado: de $start até $end');
    }

    var widht_screen = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Cadastro de Ordem de Serviço MOBILE'),
      ),
      body: Scrollbar(
          controller: ScrollController(
            initialScrollOffset: 0,
            keepScrollOffset: true,
          ),
          thickness: 12,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Expanded(
                flex: 1,
                child: DropMenuForm(
                  labelText: 'REBOCADOR',
                  options: const [
                    "MCC",
                    "SLB MELODIA",
                    'AÇU',
                    "ATLÂNTICO",
                    'ÁGATA',
                    "ALDEBARAN",
                    "ALTAIR",
                    "F. ANDREIS XI",
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
              Row(
                children: [
                  Expanded(
                    child: CaixaDeTexto(
                        controller: relatorio_controller.funcionarios,
                        labelText: 'RESPONSÁVEL PELA EXECUÇÃO'),
                  ),
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
                          setState(() {
                            // Formata a data para o formato desejado
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(date);
                            // Define o texto do controlador com a data formatada
                            relatorio_controller.dataAbertura.text =
                                formattedDate;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              GlassCard(
                width: widht_screen,
                height: 70,
                child: Row(children: [
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
                ]),
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
              CaixaDeTexto(
                  controller: relatorio_controller.descFalha,
                  labelText: 'DESCRIÇÃO DA FALHA'),
              CaixaDeTexto(
                  controller: relatorio_controller.ACAOTEXT,
                  labelText: 'SERVIÇO EXECUTADO'),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RadioButtonGroup(
                        textLabel: "Serviço Finalizado?",
                        niveis: relatorio_controller.opcoes,
                        nivelSelecionado: relatorio_controller.nivelSelecionado,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RadioButtonGroup(
                        textLabel: "FORA DE OPERAÇÃO",
                        niveis: relatorio_controller.opcoes,
                        nivelSelecionado: relatorio_controller.optionSelected,
                      ),
                    ),
                  ),
                ],
              ),
              CaixaDeTexto(
                controller: relatorio_controller.obs,
                labelText: "Observações ",
                height: 30,
              ),
              cardinfo("Itens Opcionais"),
              Row(
                children: [
                  TextButton(
                      onPressed: () {}, child: Text("Colocar fotos da peça")),
                  Expanded(
                    child: TimeRangePickerWidget(
                      onIntervalSelected: (TimeOfDay start, TimeOfDay end) {
                        TimeOfDay roomBooked = TimeOfDay.fromDateTime(
                            DateTime.parse(
                                '2021-10-10 ${start.hour}:${start.minute}:00Z'));

                        print('Intervalo selecionado: de $start até $end');
                        relatorio_controller.horarios.text =
                            roomBooked.toString();
                      },
                    ),
                  ),
                  Expanded(
                    child: CaixaDeTexto(
                      controller: relatorio_controller.dataConclusao,
                      labelText: 'DATA Conclusão',
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
                          relatorio_controller.dataAbertura.text =
                              formattedDate;
                        }
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
                ],
              ),
              btnsRows(context),
            ],
          )),
      floatingActionButton: ThreeFloatingButtons(),
      bottomNavigationBar: CustomNavBar(
        navBarItems: [
          NavigationBarItem(
              label: 'Excel Clone',
              iconData: Icons.add,
              onPress: () {
                Get.to(DatabaseMongoDBTableScreen());
              }),
          NavigationBarItem(
              label: 'OCR Page',
              iconData: Icons.date_range_outlined,
              onPress: () {
                Get.to(PhotoGalleryScreen());
              }),
          NavigationBarItem(
              label: 'Banco de Dados', iconData: Icons.search, onPress: () {}),
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
            ),
            const Divider(
              thickness: 2,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  Widget btnsRows(context) {
    final CadastroController relatorio_controller =
        Get.put(CadastroController());
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
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
            text: 'Limpar'),
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
                  relatorio_controller.EQUIPAMENTO_TEXT.clear();

                  relatorio_controller.contadorServices++;
                },
                color: Colors.blue,
                text:
                    'Adicionar mais dados - (${relatorio_controller.contadorServices.value})');
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
                relatorio_controller.EQUIPAMENTO_TEXT.clear();

                relatorio_controller.contadorServices++;
              },
              color: Colors.blue,
              text: 'Adicionar mais dados');
        }),
      ],
    );
  }
}
