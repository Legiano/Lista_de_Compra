import 'package:flutter/material.dart';
import 'produto.dart';

class CadastroProduto extends StatefulWidget {
  const CadastroProduto({Key? key}) : super(key: key);

  @override
  _CadastroProdutoState createState() => _CadastroProdutoState();
}

class _CadastroProdutoState extends State<CadastroProduto> {
  final _formKey = GlobalKey<FormState>(); 
  final _descricaoController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _valorUnitarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cadastro de Produto'),
         backgroundColor:  Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantidadeController,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorUnitarioController,
                decoration: const InputDecoration(labelText: 'Valor Unitário'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor unitário';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final novoProduto = Produto(
                      descricao: _descricaoController.text,
                      quantidade: int.parse(_quantidadeController.text),
                      valorUnitario: double.parse(_valorUnitarioController.text),
                      comprado: false,
                    );
                    Navigator.pop(context, novoProduto); 
                  }
                },
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _quantidadeController.dispose();
    _valorUnitarioController.dispose();
    super.dispose();
  }
}

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
      appBar: AppBar(
        title: const Text('Lista de Compras'),
      ),
      backgroundColor: Colors.lightBlue[50],
      body: Column(
        children: [
          Expanded(
            child: listaDeProdutos.isEmpty
                ? const Center(child: Text('Nenhum produto cadastrado.'))
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
                ElevatedButton(
                  onPressed: _calcularTotalDaCompra,
                  child: const Text('Total da Compra'),
                ),
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
      totalDaCompra = listaDeProdutos.fold(0.0, (sum, produto) => sum + produto.valorTotal);
    });
  }
}