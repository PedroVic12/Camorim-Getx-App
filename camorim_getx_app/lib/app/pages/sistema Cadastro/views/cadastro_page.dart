// ignore_for_file: non_constant_identifier_names

import 'package:camorim_getx_app/app/controllers/imagem%20e%20pdf/pegando_arquivo_page.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/cadastro_desktop.dart';
import 'package:camorim_getx_app/widgets/BotaoWidget.dart';
import 'package:camorim_getx_app/widgets/CustomCheckBox.dart';
import 'package:camorim_getx_app/widgets/DropMenuForm.dart';
import 'package:camorim_getx_app/widgets/NavBarCustom.dart';
import 'package:camorim_getx_app/widgets/RadioButtonGroup.dart';
import 'package:camorim_getx_app/widgets/TextLabel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/AppBarPersonalizada.dart';
import '../../../../widgets/CaixaDeTexto.dart';
import '../../CRUD Excel/controllers/excel_controller.dart';

//TODO -> LER FOTO DO DOCUMENTO
//TODO ->  EXTRAIR INFORMACOES
//TODO -> CADASTRO NO SISTEMA E NO EXCEL ONLINE
//TODO -> GERAR RELATORIO PDF DIGITAL (EQUIPAMENTO-REBOCADOR-DATA)
//TODO -> ENVIAR RELATORIO POR EMAIL COM DATA DE ENVIO

class SistemaCadastroPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final ExcelController excel_controller = Get.put(ExcelController());
  final CadastroController relatorio_controller = Get.put(CadastroController());

  SistemaCadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizada(
        titulo: 'RELATÓRIO ORDEM DE SERVIÇO',
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          PegandoArquivosPage(),
          FormsListRelatorio(),
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
                                element.acao,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
      bottomNavigationBar: CustomNavBar(
        navBarItems: [
          NavigationBarItem(
              label: 'Cadastro',
              iconData: Icons.date_range_outlined,
              onPress: () {
                // Get.to(CalendarioWidget());
              }),
          NavigationBarItem(
              label: 'TELA CONSULTA',
              iconData: Icons.search,
              onPress: () {
                Get.to(SistemaCadastroDesktop());
              }),
        ],
      ),
    );
  }
}

class FormsListRelatorio extends StatelessWidget {
  FormsListRelatorio({super.key});

  final CadastroController relatorio_controller = Get.put(CadastroController());

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 12,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          DropMenuForm(
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
          CaixaDeTexto(
            controller: relatorio_controller.dataAbertura,
            labelText: 'DATA ABERTURA',
            onTap: () async {
              var date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2001),
                lastDate: DateTime(2030),
                locale: const Locale(
                    'pt', 'BR'), // Define o local para Português do Brasil
              );
              if (date != null) {
                // Formata a data para o formato desejado
                String formattedDate = DateFormat('dd/MM/yyyy').format(date);
                // Define o texto do controlador com a data formatada
                relatorio_controller.dataAbertura.text = formattedDate;
              }
            },
          ),
          CaixaDeTexto(
              controller: relatorio_controller.descFalha,
              labelText: 'DESCRIÇÃO DA FALHA'),
          DropMenuForm(
            labelText: 'EQUIPAMENTO',
            options: const [
              'ALUGUEL DE VEÍCULOS',
              "CARTÓRIO",
              'COMBUSTÍVEL',
              "ESTADIAS",
              "CUSTOS DIVERSOS",
              "ESTACIONAMENTO",
              "PEDÁGIO",
              "TRANSPORTE - VIAGENS",
              "ALIMENTAÇÃO - VIAGENS ",
              'BENS DE NATUREZA PERMANENTE',
              'CORREIOS'
            ],
            textController: relatorio_controller.EQUIPAMENTO_TEXT,
          ),
          DropMenuForm(
            labelText: 'MANUTENÇÃO',
            options: const [
              'CORRETIVA',
              "PREVENTIVA",
              'MELHORIA',
            ],
            textController: relatorio_controller.manutencao,
          ),
          CaixaDeTexto(
              controller: relatorio_controller.ACAOTEXT,
              labelText: 'SERVIÇO EXECUTADO'),
          CaixaDeTexto(
              controller: relatorio_controller.funcionarios,
              labelText: 'RESPONSÁVEL PELA EXECUÇÃO'),
          DropMenuForm(
            labelText: 'OFICINA',
            options: const [
              'ELÉTRICA',
              "MECÂNICA",
            ],
            textController: relatorio_controller.oficina,
          ),
          const TextLabel(texto: 'Serviço Finalizado??'),
          RadioButtonGroup(
            niveis: relatorio_controller.opcoes,
            nivelSelecionado: relatorio_controller.nivelSelecionado,
          ),
          CaixaDeTexto(
              controller: relatorio_controller.dataConclusao,
              labelText: 'DATA CONCLUSÃO'),
          const TextLabel(texto: 'FORA DE OPERAÇÃO'),
          RadioButtonGroup(
            niveis: relatorio_controller.opcoes,
            nivelSelecionado: relatorio_controller.optionSelected,
          ),
          CaixaDeTexto(
              controller: relatorio_controller.obs, labelText: 'OBSERVAÇÕES'),
        ],
      ),
    );
  }
}

class CadastroController extends GetxController {
  final NivelRepository nivelRepository = NivelRepository();
  final OpcoesRepository opcoesRepository = OpcoesRepository();

  final EQUIPAMENTO_TEXT = TextEditingController();
  final nomeRebocadorText = TextEditingController();
  final ACAOTEXT = TextEditingController();
  final STATUSTEXT = TextEditingController();
  final GRUPO = TextEditingController();
  final dataAbertura = TextEditingController();
  final descFalha = TextEditingController();
  final manutencao = TextEditingController();
  final funcionarios = TextEditingController();
  final oficina = TextEditingController();
  final dataConclusao = TextEditingController();
  final obs = TextEditingController();
  var opcaoSelecionada = <String>[].obs;
  var opcoes = <String>[].obs;
  var niveis = <String>[].obs;

  final servicoFinalizado = false.obs;
  final _formKey = GlobalKey<FormState>();
  final array_cadastro = <CadastroModel>[].obs;
  var nivelSelecionado = ''.obs;
  var optionSelected = ''.obs;

  // Modelo atual
  var currentModel = Rx<CadastroModel?>(null);

  @override
  void onInit() {
    super.onInit();
    niveis.assignAll(nivelRepository.retornaNiveis());
    opcoes.assignAll(opcoesRepository.retornarOpcoes());
  }

  void salvar(BuildContext context) {
    if (EQUIPAMENTO_TEXT.text.isEmpty ||
        nomeRebocadorText.text.isEmpty ||
        dataAbertura.text.isEmpty ||
        descFalha.text.isEmpty ||
        oficina.text.isEmpty) {
      Get.snackbar(
        "Erro",
        "Todos os campos devem ser preenchidos",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final model = CadastroModel(
      EQUIPAMENTO_TEXT.text,
      rebocador: nomeRebocadorText.text,
      acao: descFalha.text,
      status: dataAbertura.text,
      tipoManutencao: servicoFinalizado.value,
    );
    currentModel.value = model;

    array_cadastro.add(model);

    // Reset the text fields after saving
    EQUIPAMENTO_TEXT.clear();
    nomeRebocadorText.clear();
    dataAbertura.clear();
    descFalha.clear();
    oficina.clear();

    // Show a success message
    Get.snackbar(
      "Sucesso",
      "Cadastro salvo com sucesso",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class CadastroModel {
  final String equipamento;
  final String rebocador;
  final String acao;
  final String status;
  final bool tipoManutencao;

  CadastroModel(
    this.equipamento, {
    required this.rebocador,
    required this.acao,
    required this.status,
    required this.tipoManutencao,
  });
}

class NivelRepository {
  List<String> retornaNiveis() {
    return [
      'SIM',
      'NÂO',
    ];
  }
}

class OpcoesRepository {
  List<String> retornarOpcoes() {
    return [
      'SIM',
      'NÂO',
    ];
  }
}
