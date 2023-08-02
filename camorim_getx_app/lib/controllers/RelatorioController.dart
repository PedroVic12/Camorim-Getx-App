import 'package:camorim_relatoios_os/models/relatorio_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RelatorioController extends GetxController {
  RxList<RelatorioModel> relatorios = RxList<RelatorioModel>([]);
  List<RelatorioModel> get relatorio => relatorios.toList();

  TextEditingController nomeRebocadorText = TextEditingController();
  TextEditingController descricaoFalhaText = TextEditingController();
  TextEditingController servicoExecutadoText = TextEditingController();

  var servicoFinalizado = false.obs;
  var itemCount = 0.obs;

  @override
  void onClose() {
    super.onClose();
    nomeRebocadorText.dispose();
    descricaoFalhaText.dispose();
    servicoExecutadoText.dispose();
  }

  void addRelatorio() {
    final novoRelatorio = RelatorioModel(
      nomeRebocadorText.text,
      descricaoFalhaText.text,
      servicoExecutadoText.text,
      servicoFinalizado.value,
    );
    relatorios.add(novoRelatorio);
    itemCount.value = relatorios.length;

    nomeRebocadorText.clear();
    descricaoFalhaText.clear();
    servicoExecutadoText.clear();
    servicoFinalizado.value = false;
  }

  void removerRelatoio(int index) {
    relatorios.removeAt(index);
    itemCount.value = relatorios.length;
  }
}
