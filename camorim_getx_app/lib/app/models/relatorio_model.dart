class RelatorioModel {
  final String? nome_rebocador;
  final String? descricao_falha;
  final String? servico_executado;
  final bool? servico_finalizado;

  RelatorioModel(this.nome_rebocador, this.descricao_falha,
      this.servico_executado, this.servico_finalizado);
}
