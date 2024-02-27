import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import 'controllers/grovyle_pokemon_controller.dart';

class ExcelExample extends StatefulWidget {
  @override
  _ExcelExampleState createState() => _ExcelExampleState();
}

class _ExcelExampleState extends State<ExcelExample> {
  final GrovyleController grovyleController = GrovyleController();
  final Map<String, dynamic> sampleData = {
    'embarcacao': 'Balsa Camorim',
    'descricaoFalha': 'MCA BB com falha na partida',
    'equipamento': 'MCA BB',
  };

  late List<Map<String, dynamic>> _dataList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dataList = await grovyleController.readData(grovyleController.wb);
    setState(() {
      _dataList = dataList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Excel Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () async {
                await grovyleController.createData(sampleData);
                _loadData();
              },
              child: Text('Adicionar Dados'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _buildDataTable(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    if (_dataList.isEmpty) {
      return Center(child: Text('Nenhum dado encontrado'));
    } else {
      return DataTable(
        columns: [
          DataColumn(label: Text('Embarcação')),
          DataColumn(label: Text('Descrição da Falha')),
          DataColumn(label: Text('Equipamento')),
          DataColumn(label: Text('Data de Cadastro')),
          DataColumn(label: Text('Ações')),
        ],
        rows: _dataList.map((data) {
          return DataRow(cells: [
            DataCell(Text(data['embarcacao'])),
            DataCell(Text(data['descricaoFalha'])),
            DataCell(Text(data['equipamento'])),
            DataCell(Text(data['dataCadastro'])),
            DataCell(
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  //await grovyleController.deleteData(data['id']);
                  _loadData();
                },
              ),
            ),
          ]);
        }).toList(),
      );
    }
  }
}
