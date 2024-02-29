import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/CONSULTA/showDadosCadastrados.dart';
import 'package:camorim_getx_app/widgets/table_excel_grid.dart';
import 'package:flutter/material.dart';

class ConsultaMobileRelatorio extends StatelessWidget {
  const ConsultaMobileRelatorio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ConsultaMobileRelatorio'),
        ),
        body: EditableTable());
  }
}

class ConsultarDatabaseRelatorio extends StatelessWidget {
  const ConsultarDatabaseRelatorio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ConsultarDatabaseRelatorio'),
        ),
        body: Container(
            color: Colors.blueGrey.shade300,
            child: ShowTableDadosCadastrados()));
  }
}
