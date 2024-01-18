import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/pages/Scanner PDF/controller/nota_fiscal_controller.dart';

class TableCustom extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;

  const TableCustom({super.key, required this.columns, required this.rows});

  void onSort(int columnIndex, bool ascending) {
    var repository = Get.find<NotaFiscalRepository>();
    repository.sortProducts(columnIndex, ascending);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Table(
        border: TableBorder.all(),
        children: [
          //! Colunas
          TableRow(
            decoration: BoxDecoration(color: Colors.redAccent),
            children: columns.map((col) {
              return TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: InkWell(
                      onTap: () => onSort(1, true),
                      child: Text(
                        col,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          //! Linhas

          ...rows.map((row) {
            return TableRow(
              decoration: BoxDecoration(color: Colors.white),
              children: row.map((cell) {
                return TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(cell),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ],
      ),
    );
  }
}
