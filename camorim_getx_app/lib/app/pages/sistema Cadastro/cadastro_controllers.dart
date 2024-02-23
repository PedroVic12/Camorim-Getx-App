import 'dart:convert';

import 'package:camorim_getx_app/app/pages/Relatorio%20OS/models/RelatorioModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as DioApp;
import 'package:http/http.dart' as http;

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
  final horarios = TextEditingController();

  var opcaoSelecionada = <String>[].obs;
  var opcoes = <String>[].obs;
  var niveis = <String>[].obs;

  final servicoFinalizado = false.obs;
  final _formKey = GlobalKey<FormState>();
  final array_cadastro = <RelatorioOrdemServico>[].obs;
  var nivelSelecionado = ''.obs;
  var optionSelected = ''.obs;

  // Modelo atual
  var currentModel = Rx<CadastroModel?>(null);
  final relatorio_array = <RelatorioOrdemServico>[].obs;
  DioApp.Dio dio = DioApp.Dio();

  @override
  void onInit() {
    super.onInit();
    niveis.assignAll(nivelRepository.retornaNiveis());
    opcoes.assignAll(opcoesRepository.retornarOpcoes());
    getDataBase();
  }

  Future<void> getDataBase() async {
    try {
      final resposta = await http
          .get(Uri.parse("https://docker-raichu.onrender.com/repository-os"));

      print(resposta.statusCode);

      if (resposta.statusCode == 200) {
        // Decodifica o JSON para uma lista de objetos
        final List<dynamic> jsonData = jsonDecode(resposta.body)["data"];

        final decodedReponse = utf8.decode(resposta.bodyBytes);
        final dados = jsonDecode(decodedReponse);

        print("\n\nDEBUG = ${dados["data"][0]}");
        print(dados["data"].length);

        // Mapeia a lista de objetos para uma lista de objetos do tipo RelatorioOrdemServico
        relatorio_array.value = (dados["data"] as List)
            .map((item) => RelatorioOrdemServico.fromJson(item ?? {}))
            .toList();
      }
      update();
    } catch (error) {
      print("Erro ao carregar os dados ${error.toString()}");
      Get.snackbar('Erro', error.toString());
    }
  }

  void salvarDadosCadastradosRelatorio(context) async {
    try {
      salvar(context);
      gerarRelatorioPDF();
      enviarEmail();
      salvarBancoDeDados();
      Get.snackbar('Sucesso', "Cadastro Feito!",
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          backgroundColor: Colors.green);
    } on Exception catch (e) {
      print(e);
    }
  }

  void gerarRelatorioPDF() {
    // !Gerar relatório em PDF
  }

  void enviarEmail() {}

  void salvarBancoDeDados() {}

  void updateExcelWebFile() {}

  void salvar(BuildContext context) {
    if (EQUIPAMENTO_TEXT.text.isEmpty ||
        dataAbertura.text.isEmpty ||
        descFalha.text.isEmpty ||
        oficina.text.isEmpty) {
      Get.snackbar("Erro", "Todos os campos devem ser preenchidos",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      return;
    }

    final model = RelatorioOrdemServico(
        numeroOS: '1',
        rebocador: nomeRebocadorText.text.toString(),
        dataInicial: dataAbertura.text,
        descFalha: descFalha.text,
        equipamento: EQUIPAMENTO_TEXT.text,
        tipoManutencao: manutencao.text,
        servicoExecutado: ACAOTEXT.text,
        funcionario: [funcionarios.text],
        oficina: oficina.text,
        obs: obs.text,
        status_finalizado: nivelSelecionado,
        foraOperacao: optionSelected,
        dataFinal: dataConclusao.text);

    array_cadastro.add(model);
  }

  void resetLabels() {
    // Reset the text fields after saving
    nomeRebocadorText.clear();
    oficina.clear();
    horarios.clear();
    funcionarios.clear();
    dataAbertura.clear();
    EQUIPAMENTO_TEXT.clear();
    descFalha.clear();
    dataAbertura.clear();
    ACAOTEXT.clear();
    manutencao.clear();
    obs.clear();
    dataAbertura.clear();
    dataConclusao.clear();
  }
}

class RelatorioOrdemServico {
  String numeroOS;
  String rebocador;
  String dataInicial;
  String descFalha;
  String? dataFinal;
  String equipamento;
  String tipoManutencao;
  String servicoExecutado;
  List<String> funcionario;
  String oficina;
  String obs;
  RxString foraOperacao;
  RxString status_finalizado;

  RelatorioOrdemServico({
    required this.numeroOS,
    required this.rebocador,
    required this.dataInicial,
    required this.descFalha,
    required this.equipamento,
    required this.tipoManutencao,
    required this.servicoExecutado,
    required this.funcionario,
    required this.oficina,
    required this.obs,
    required this.status_finalizado,
    required this.foraOperacao,
    required this.dataFinal,
  });

  factory RelatorioOrdemServico.fromJson(Map<String, dynamic> json) {
    return RelatorioOrdemServico(
      numeroOS: json['N_OS'].toString(),
      rebocador: json['BARCO'].toString(),
      dataInicial: json['DATA_INICIO'].toString(),
      descFalha: json['DESC_FALHA'].toString(),
      equipamento: json['EQUIPAMENTO'].toString(),
      tipoManutencao: json['MANUTENCAO'].toString(),
      servicoExecutado: json['SERV_EXECUTADO'].toString(),
      funcionario:
          json['RESPONSAVEL'] != null ? [json['RESPONSAVEL'].toString()] : [],
      oficina: json['OFICINA'].toString(),
      status_finalizado: RxString(json['FINALIZADO']),
      dataFinal: json['DATA_CONCLUSAO'] != null
          ? json['DATA_CONCLUSAO'].toString()
          : null,
      foraOperacao: RxString(json['FORA_OPERACAO']),
      obs: json['OBS'].toString(),
    );
  }
  Map<String, dynamic> toMap() => {
        'rebocador': rebocador,
        'dataInicial': dataInicial,
        'descFalha': descFalha,
        'dataFinal': dataFinal,
        'equipamento': equipamento,
        'tipoManutencao': tipoManutencao,
        'servicoExecutado': servicoExecutado,
        'funcionario': funcionario,
        'oficina': oficina,
        'obs': obs,
        'status_finalizado': status_finalizado,
      };
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
