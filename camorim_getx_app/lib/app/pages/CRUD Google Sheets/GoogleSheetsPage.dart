// ignore_for_file: non_constant_identifier_names

import 'package:camorim_getx_app/app/pages/CRUD%20Excel/view/crud_excel_page.dart';
import 'package:camorim_getx_app/app/pages/CRUD%20Google%20Sheets/user_fields.dart';
import 'package:camorim_getx_app/app/pages/CRUD%20Google%20Sheets/user_sheets_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class GsheetsController extends GetxController {
  final nomeController = TextEditingController(); // Use nomeController aqui
  final controllerEmail = TextEditingController();
  RxBool isPadawan = false.obs;
}

class GoogleSheetsPage extends StatefulWidget {
  const GoogleSheetsPage({super.key});

  @override
  State<GoogleSheetsPage> createState() => _GoogleSheetsPageState();
}

class _GoogleSheetsPageState extends State<GoogleSheetsPage> {
  final sheet_controller = Get.put(GsheetsController());

  Future insertUsers() async {
    final users = [
      User(id: 1, name: 'Peter Parker', email: 'email.com', isPadawan: true),
      User(
          id: 2,
          name: 'Anakin Skywalker',
          email: 'email.com',
          isPadawan: false),
      User(id: 3, name: 'Pedro Victor', email: 'email.com', isPadawan: true),
    ];

    for (var user in users) {
      print(user.toJson());
      await UserSheetsApi.insert(user.toJson().values.toList());
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  final formKey = GlobalKey<FormState>();

  Future insertFromForm() async {
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch, // Generate a unique ID
      name: sheet_controller.nomeController.text,
      email: sheet_controller.controllerEmail.text,
      isPadawan: sheet_controller.isPadawan.value,
    );

    await UserSheetsApi.insert(user.toJson().values.toList());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Excel'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: new InkWell(
                    child: new Text('ABRIR LINK DA PLANILHA'),
                    onTap: () => launch(
                        'https://docs.google.com/spreadsheets/d/1F4xp1uLQvuUplDPqV_Vg5I-Wp3-7dNlpmY4IQOPTuak/edit#gid=0')),
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.to(ContactForm());
                  },
                  child: Text('Ir para o CRUD Excel')),
              const SizedBox(
                height: 16,
              ),
              buildName(sheet_controller),
              const SizedBox(
                height: 16,
              ),
              buildEmail(sheet_controller),
              const SizedBox(
                height: 16,
              ),
              buildPadawan(sheet_controller),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    insertFromForm();
                    Get.snackbar('Sucesso',
                        'Dados do formulário inseridos na planilha!');
                  }
                },
                child: Text('Save Data'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      insertUsers();
                      Get.snackbar('Sucesso', 'Foi inserido na planilha!');
                    } catch (e) {
                      print('nao foi possivel $e');
                    }
                  },
                  child: const Text('SALVAR DADOS VINDO DE UM JSON')),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildName(GsheetsController controller) {
  return TextFormField(
      controller: controller.nomeController,
      decoration: const InputDecoration(
        labelText: 'Nome',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value != null && value.isEmpty ? 'Enter name' : null);
}

Widget buildEmail(GsheetsController controller) {
  return TextFormField(
    controller: controller.controllerEmail,
    decoration: const InputDecoration(
      labelText: 'Email',
      border: OutlineInputBorder(),
    ),
  );
}

Widget buildPadawan(GsheetsController controller) {
  return Obx(() {
    return SwitchListTile(
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        value: controller.isPadawan.value,
        title: const Text('Voce é Padawan?'),
        onChanged: (value) {
          controller.isPadawan.value = value;
        });
  });
}
