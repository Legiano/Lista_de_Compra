import 'package:flutter/material.dart';
import 'cadastro_produto.dart';
import 'produto.dart';

class ListaDeProdutosPage extends StatefulWidget {
  const ListaDeProdutosPage({Key? key}) : super(key: key);

  @override
  _ListaDeProdutosPageState createState() => _ListaDeProdutosPageState();
}

class _ListaDeProdutosPageState extends State<ListaDeProdutosPage> {
  List<Produto> listaDeProdutos = [];
  double totalDaCompra = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Lista de Compras'),
         backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: listaDeProdutos.isEmpty
                ? const Center(child: Text('Cadastre um produto!'))
                : ListView.builder(
                    itemCount: listaDeProdutos.length,
                    itemBuilder: (context, index) {
                      final produto = listaDeProdutos[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Checkbox(
                                value: produto.comprado,
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    setState(() {
                                      produto.comprado = value;
                                    });
                                  }
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      produto.descricao,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Text('Quantidade: ${produto.quantidade}'),
                                    Text(
                                      'Valor Unitário: R\$${produto.valorUnitario.toStringAsFixed(2)}',
                                    ),
                                    Text(
                                      'Valor Total: R\$${produto.valorTotal.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _excluirProduto(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: R\$${totalDaCompra.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navegarParaCadastro(context);
        },
        tooltip: 'Adicionar Produto',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _navegarParaCadastro(BuildContext context) async {
    final novoProduto = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CadastroProduto()),
    );

    if (novoProduto != null) {
      setState(() {
        listaDeProdutos.add(novoProduto);
        _calcularTotalDaCompra();
      });
    }
  }

  void _excluirProduto(int index) {
    setState(() {
      listaDeProdutos.removeAt(index);
      _calcularTotalDaCompra();
    });
  }

  void _calcularTotalDaCompra() {
    setState(() {
      totalDaCompra = listaDeProdutos.fold(0.0, (sum, produto) => sum + (produto.valorTotal));
    });
  }
}