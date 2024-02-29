import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:camorim_getx_app/widgets/button_async.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../app/pages/CRUD Excel/controllers/bulbassaur_excel.dart';
import '../app/pages/Scanner PDF/controller/nota_fiscal_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class TableCustom extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;

  const TableCustom({Key? key, required this.columns, required this.rows});

  void onSort(int columnIndex, bool ascending) {
    var repository = Get.put(NotaFiscalRepository());
    repository.sortProducts(columnIndex, ascending);
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se o número de colunas é maior que 6
    bool hasHorizontalScroll = columns.length > 6;

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Table(
        textDirection: TextDirection.ltr,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: hasHorizontalScroll
            ? {for (var i = 0; i < columns.length; i++) i: FlexColumnWidth(1)}
            : {
                for (var i = 0; i < columns.length; i++)
                  i: IntrinsicColumnWidth()
              },
        border: TableBorder.all(),
        children: [
          //! Colunas
          TableRow(
            decoration: BoxDecoration(color: Colors.redAccent),
            children: columns.map((col) {
              return TableCell(
                child: Container(
                  child: Center(
                    child: InkWell(
                        onTap: () => onSort(1, true),
                        child: CustomText(
                          text: col,
                          size: 8,
                          weight: FontWeight.bold,
                        )),
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
                      padding: const EdgeInsets.all(4.0),
                      child: CustomText(
                        text: cell,
                        size: 8,
                      )),
                );
              }).toList(),
            );
          }).toList(),
        ],
      ),
    );
  }
}
