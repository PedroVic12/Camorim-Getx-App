// ignore_for_file: non_constant_identifier_names

import 'package:camorim_getx_app/pages/CRUD%20EXCEL/user_fields.dart';
import 'package:gsheets/gsheets.dart';

class UserSheetsApi {
  static const _credential = r'''
{
  "type": "service_account",
  "project_id": "camorim",
  "private_key_id": "ff3dd685a7018791ef2a4f766f53d51a0440a39c",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCVzsqGC9mZYVP7\nglcpPUTceSa3O5k4dRobLbFkTgHYktn13dScmkmsMXslOlngpaMSJWUaQ+AGQkAc\n1RO8M3M0vsjekDfVjP2h5C7bdn1O4H7OFc3lC8JJcmEOR8T/XVyUpq9QVgCWTIF9\nNIuFz+ZCrJI2iP/a7ysdWh3CsRr0S8hK/11YTuXrP8koB68EBIOEPfg44Kh6yZRO\nF/1zui+O/YtPVIyXb9ptWKeXRZGmWNW5yCtw7IOQRPLusnP/DwCj9Nz/yPvSMg69\nMN+0te6eGGvtsV8EKa8bMHt7/zHvsGUUE7FdTeZA6f4XR0W6Y0aEEPeOIfkJyyb9\nysvnGzbTAgMBAAECggEAE6HMd6Gg7BFNrLWpj314gz4bPUMBstzhxXMI/sCcTFH+\nX1KpVLaBdh/r5/aMJbz/MFcXN0hy2M8g0MZ5th21+NERyNz0fDdkW61oGJmgFVCl\nPYOs/lm6pd5n6rOsFN0az15Ctk/29rti8tIKgMg8gDtWU/BDO2FBcLDJGqUUB7Sd\nWPMjLmpc8VIEyDsMUT/NPiVMS5rd3mrllXvkU7RJbRibSVI9srXCbG4c91oXw/JN\nlSmUAx8InmUcfCKZlUFWdMKzLSbxK6QLKCITvXm0lH67/AHUEl2AjwscmXju6XWS\nVjBl1CT0yUjHl7V45ZQwd2BzQl35d2dnx0axhIPjIQKBgQDKlpEAnalrYdTuqU2j\nzh1diqJP3jfCUsRCAYjJuVaysZwfOYXp9c+otIWmk0X17hXK5xhC710UnqVviSiD\nGcovVHReetDRRD2Bnfws/apSW1s1z3iDRFH9ZjM8yYN99E1xrdM4DKa6oM8PFbJG\nP1+nZn06fnVmIuyf4pUVxuzxIQKBgQC9TeEpQBPUWwnT4qGGnmsuFY0ZOO2PmjRj\nHSqfeoXpStT9Fb8qKqa0AQgE84Nl07ZdqJRcb4aHW69+WhNNKxwUY5KPL6R4/W2e\noOAjeXcQZhxqoZ5Gf5sJ4Cj3zEucx7sgeaZAGUM2tOEBvYuATmAJqOYfMTrsboLd\naG0sjw1FcwKBgQCCX+NxQgWF1a/y54HPqRW83TsXqyq3JAypbdNZ/qyM00Bl198W\ncdrx9zsLuDuNyWq86Xvzl5ePbYmJ/frUZAR58R/yrZc1FXV/tOxVB+pUlfZc6ufj\nklQxf1P6CrVUmaQ9RGBp8bpa4KJgUtYn3yDv2kU9H6Tt1gvx2R+YpCxYAQKBgAbz\nIv8GsTOsm/HBcjik/D5W4DU6183b1WyGF5h/QQdNjgA0mi4MHs6g8xBreDl2yk0p\n8Thrh77UaN70o5zDpmZBOZI0J4+hjjKyqUfkH7DkbsqjYFIqQSDdr+NZBrWcx4vr\nq2TTCJqrjU8pDEQLnI7+OmSOxCEF9Zv3R3rJTa1tAoGBAKcYX0xM1LFhRNbM/CRq\nhAlG4/yLouwvMv0p00uxX2PaGdTTd2axQ6lgoZsRfYtITM8msL/nqARJErh0OZhF\neEajVAowPYHL+piCqoWnjJZ8BunzoYGp3O5seltDm+KszVBPd6nBbJypplo+9Pg8\nP8pYyijvyNAC6xlAIh6s9+Ul\n-----END PRIVATE KEY-----\n",
  "client_email": "camorim@camorim.iam.gserviceaccount.com",
  "client_id": "101633404165239565728",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/camorim%40camorim.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

''';

  static final _spreadSheetId = '1F4xp1uLQvuUplDPqV_Vg5I-Wp3-7dNlpmY4IQOPTuak';

  static final _googleSheets = GSheets(_credential);

  static Worksheet? _userSheet;

  static Future init() async {
    try {
      final planilha = await _googleSheets.spreadsheet(_spreadSheetId);
      _userSheet = await _getWorksheet(planilha, title: 'Página1');

      // Obtenha todas as linhas da planilha.
      var allRows = await _userSheet!.values.allRows();

      // Verifique se a primeira linha já existe.
      if (allRows.isEmpty) {
        final primeira_linha = UserFields.getFields();
        _userSheet!.values.insertRow(1, primeira_linha);
      }
    } catch (e) {
      print('Erro ao iniciar a API $e');
    }
  }

  static Future<Worksheet> _getWorksheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(rowList) async {
    if (_userSheet == null) {
      return;
    }

    // Obtenha todas as linhas da planilha.
    var allRows = await _userSheet!.values.allRows();
    print(allRows);

    // Insira a nova linha após a última linha existente.
    _userSheet!.values.insertRow(allRows.length + 1, rowList);
  }
}
