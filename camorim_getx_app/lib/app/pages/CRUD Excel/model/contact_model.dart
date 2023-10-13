class Contact {
  final String name;
  final String email;

  Contact({required this.name, required this.email});
}

class ExcelTitle {
  final String nameTitle;
  final String emailTitle;

  ExcelTitle({required this.nameTitle, required this.emailTitle});
}

class RelatorioModel {
  String? nomeRebocador;
  String? descricaoFalha;
  String? servicoExecutado;
  bool servicoFinalizado;

  RelatorioModel({
    this.nomeRebocador,
    this.descricaoFalha,
    this.servicoExecutado,
    this.servicoFinalizado = false,
  });
}
