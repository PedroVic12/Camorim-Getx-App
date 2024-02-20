import 'package:camorim_getx_app/app/pages/Relatorio%20OS/models/RelatorioModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void onInit() {
    super.onInit();
    niveis.assignAll(nivelRepository.retornaNiveis());
    opcoes.assignAll(opcoesRepository.retornarOpcoes());
  }

  void salvarDadosCadastradosRelatorio(context) async {
    try {
      salvar(context);
      gerarRelatorioPDF();
      enviarEmail();
      salvarBancoDeDados();
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

    final model = RelatorioOrdemServico(
        rebocador: nomeRebocadorText.text,
        dataInicial: dataAbertura.text,
        descFalha: descFalha.text,
        equipamento: EQUIPAMENTO_TEXT.text,
        tipoManutencao: manutencao.text,
        servicoExecutado: ACAOTEXT.text,
        funcionario: [funcionarios.text],
        oficina: oficina.text,
        obs: obs.text,
        status_finalizado: nivelSelecionado,
        dataFinal: dataConclusao.text);

    array_cadastro.add(model);

    // Show a success message,
    Get.snackbar(
      "Sucesso",
      "Cadastro salvo com sucesso",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void resetLabels() {
    // Reset the text fields after saving
    nomeRebocadorText.clear();
    oficina.clear();
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
  RxString status_finalizado;

  RelatorioOrdemServico({
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
    required this.dataFinal,
  });

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
