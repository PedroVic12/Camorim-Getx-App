import 'package:camorim_getx_app/pages/CRUD%20Excel/model/contact_model.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ContactController extends GetxController {
  var contacts = <Contact>[].obs;

  Future<void> addContact(Contact contact) async {
    // Aqui, adicione o contato ao arquivo Excel
    Workbook workbook = Workbook();
    Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByIndex(1, 1).setText('Name');
    sheet.getRangeByIndex(1, 2).setText('Email');
    sheet.getRangeByIndex(2, 1).setText(contact.name);
    sheet.getRangeByIndex(2, 2).setText(contact.email);
    List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // ... código para salvar bytes em arquivo ou outro local ...

    contacts.add(contact);
  }

  // Você também pode adicionar funções para update, delete e load aqui ...
}
