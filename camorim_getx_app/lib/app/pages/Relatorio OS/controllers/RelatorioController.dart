import 'package:camorim_getx_app/app/pages/Relatorio%20OS/models/RelatorioModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RelatorioController extends GetxController {
  var nomeRebocadorText = TextEditingController().obs;
  var descricaoFalhaText = TextEditingController().obs;
  var servicoExecutadoText = TextEditingController().obs;
  var servicoFinalizado = false.obs;
  var relatorio = <Relatorio>[].obs;

  void addRelatorio() {
    relatorio.add(Relatorio(
      nomeRebocador: nomeRebocadorText.value.text,
      descricaoFalha: descricaoFalhaText.value.text,
      servicoExecutado: servicoExecutadoText.value.text,
      servicoFinalizado: servicoFinalizado.value,
    ));
  }

  void removerRelatoio(int index) {
    relatorio.removeAt(index);
  }
}
