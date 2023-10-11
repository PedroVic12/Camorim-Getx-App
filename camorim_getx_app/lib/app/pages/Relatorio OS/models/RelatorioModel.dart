// relatorio_model.dart

class Relatorio {
  String? nomeRebocador;
  String? descricaoFalha;
  String? servicoExecutado;
  bool servicoFinalizado;

  Relatorio({
    this.nomeRebocador,
    this.descricaoFalha,
    this.servicoExecutado,
    this.servicoFinalizado = false,
  });
}
