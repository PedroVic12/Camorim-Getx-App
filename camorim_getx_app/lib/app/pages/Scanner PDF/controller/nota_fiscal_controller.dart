import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NotaFiscalController extends GetxController {
  final RxList<NotaFiscal> notasFiscais_ARRAY = RxList<NotaFiscal>();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController localController = TextEditingController();
  final TextEditingController produtosController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController categoriaController = TextEditingController();

  void salvarDados() {
    final notaFiscal = NotaFiscal(
      data: dataController.text,
      local: localController.text,
      produtos: produtosController.text.split(", "),
      total: double.parse(totalController.text),
    );

    notasFiscais_ARRAY.add(notaFiscal);
  }
}

class NotaFiscal {
  String data;
  String local;
  List<String> produtos;
  double total;

  NotaFiscal({
    required this.data,
    required this.local,
    required this.produtos,
    required this.total,
  });
}

class notaFiscalProduct {
  late final String data;
  late final String local;
  late final String produtos;
  late final double total;
  late final String categoria;

  notaFiscalProduct(
      {required this.data,
      required this.local,
      required this.produtos,
      required this.total,
      required this.categoria});

  notaFiscalProduct.fromJson(Map<String, dynamic> json) {
    data = json['Data'];
    local = json['Local'];
    produtos = json['Produtos'];
    total = json['Total'];
    categoria = json['Categoria'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Data'] = data;
    data['Local'] = local;
    data['Produtos'] = produtos;
    data['Total'] = total;
    data['Categoria'] = categoria;
    return data;
  }
}

class NotaFiscalRepository extends GetxController {
  NotaFiscalRepository(jsonFilePath);
  List<dynamic> _products = [];

  List<dynamic> get products => _products;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final String response = await rootBundle.loadString(
        "lib/app/pages/OCR_PAGE/repository/Nota_fiscal_OCR_template.json");
    //print(response);
    final data = json.decode(response);
    _products = data; // Supondo que o JSON é uma lista
    update(); // Notifica os ouvintes
  }

  void sortProducts(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      products.sort(
          (user1, user2) => compareString(ascending, user1.data, user2.data));
    } else if (columnIndex == 1) {
      products.sort((user1, user2) =>
          compareString(ascending, user1.categoria, user2.categoria));
    } else if (columnIndex == 2) {
      products.sort((user1, user2) =>
          compareString(ascending, user1.produtos, user2.produtos));
    } else if (columnIndex == 3) {
      products.sort(
          (user1, user2) => compareDouble(ascending, user1.total, user2.total));
    } else if (columnIndex == 4) {
      products.sort(
          (user1, user2) => compareString(ascending, user1.local, user2.local));
    }
    update(); // Notify UI of changes
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  int compareDouble(bool ascending, double value1, double value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
