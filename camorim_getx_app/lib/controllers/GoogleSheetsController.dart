import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleSheetsController extends GetxController {
  final String _sheetsUrl = "https://sheets.googleapis.com/v4/spreadsheets";
  final String _spreadsheetId = "YOUR_SPREADSHEET_ID";
  final String _apiKey = "YOUR_API_KEY";

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> addDataToSheet(List<dynamic> data) async {
    isLoading.value = true;

    var endpointUrl = '$_sheetsUrl/$_spreadsheetId/values/A1:append?valueInputOption=RAW&key=$_apiKey';
    Map<String, dynamic> body = {
      "values": [data]  // Adicione seus dados aqui
    };

    try {
      var response = await http.post(
        Uri.parse(endpointUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode != 200) {
        errorMessage.value = "Erro ao adicionar dados à planilha";
      } else {
        // Talvez atualizar algum outro estado ou informar o usuário do sucesso
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
