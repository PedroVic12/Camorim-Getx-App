// ignore_for_file: unnecessary_this

import 'dart:convert';

import 'package:camorim_getx_app/app/pages/Scanner%20PDF/controller/nota_fiscal_controller.dart';
import 'package:camorim_getx_app/widgets/TableCustom.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DataGridWidget<T> extends StatelessWidget {
  final String jsonFilePath;
  final List<String> columns;
  //final List<List<String>> excelData;

  DataGridWidget({
    super.key,
    required this.jsonFilePath,
    required this.columns,
    //required this.excelData,
  });
  final int? sortColumnIndex = 0;
  final bool isAscending = false;

  @override
  Widget build(BuildContext context) {
    //List<String> colunas = excelData.isNotEmpty ? excelData[0] : [];
    //List<List<String>> linhas =        excelData.isNotEmpty ? excelData.sublist(1) : [];

    // Certifique-se de que o NotaFiscalRepository está sendo inicializado em algum lugar do seu app
    final controller = Get.put(NotaFiscalRepository(jsonFilePath));
    return GetBuilder<NotaFiscalRepository>(
      builder: (controller) {
        if (controller.products.isNotEmpty) {
          final rows = controller.products.map((product) {
            return List.generate(
                columns.length,
                (i) =>
                    product[columns[i]]?.toString() ??
                    ''); // Handle potential null values
          }).toList();
          return TableCustom(columns: columns, rows: rows);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void onSort(int columnIndex, bool ascending) {
    var repository = Get.find<NotaFiscalRepository>();
    repository.sortProducts(columnIndex, ascending);
  }
}

class DataTableWidget extends StatelessWidget {
  final List<String> columns;
  //final List<List<String>> excelData;

  const DataTableWidget({
    super.key,
    required this.columns,
    //required this.excelData,
  });

  @override
  Widget build(BuildContext context) {
    //List<String> colunas = excelData.isNotEmpty ? excelData[0] : [];
    //List<List<String>> linhas =        excelData.isNotEmpty ? excelData.sublist(1) : [];

    // Certifique-se de que o NotaFiscalRepository está sendo inicializado em algum lugar do seu app
    return GetBuilder<NotaFiscalRepository>(
      builder: (controller) {
        if (controller.products.isNotEmpty) {
          final rows = controller.products.map((product) {
            return List.generate(
                columns.length,
                (i) =>
                    product[columns[i]]?.toString() ??
                    ''); // Handle potential null values
          }).toList();
          return TableCustom(columns: columns, rows: rows);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
