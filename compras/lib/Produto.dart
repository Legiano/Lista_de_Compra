class Produto {
  String descricao;
  int quantidade;
  double valorUnitario;
  bool comprado;

  Produto({
    required this.descricao,
    required this.quantidade,
    required this.valorUnitario,
    this.comprado = false,
  });

  double get valorTotal {
    return quantidade * valorUnitario;
  }
}