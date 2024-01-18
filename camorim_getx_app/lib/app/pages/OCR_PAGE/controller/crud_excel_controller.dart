import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

class CrudExcelController extends GetxController {
  void updateExcel(data_json_file) async {
    File file = File(data_json_file);

    Map<String, dynamic> data = {
      "Data": "2021-09-01",
      "Local": "Supermercado",
      "Produtos": "Arroz, Feijão, Macarrão",
      "Total": 100.00,
      "Categoria": "Alimentação"
    };

    // await file.append(json.encode(data));
  }
}
