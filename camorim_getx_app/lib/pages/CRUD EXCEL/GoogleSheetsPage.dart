import 'package:camorim_getx_app/pages/CRUD%20EXCEL/user_fields.dart';
import 'package:camorim_getx_app/pages/CRUD%20EXCEL/user_sheets_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoogleSheetsPage extends StatefulWidget {
  const GoogleSheetsPage({super.key});

  @override
  State<GoogleSheetsPage> createState() => _GoogleSheetsPageState();
}

class _GoogleSheetsPageState extends State<GoogleSheetsPage> {
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
      await Future.delayed(Duration(seconds: 1));
    }
  }

final TextEditingController nomeController;  // Use nomeController aqui
  late TextEditingController controllerEmail;
  late bool isPadawan;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController();
    controllerEmail = TextEditingController();
    isPadawan = false;
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
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Text(
                'LINK: https://docs.google.com/spreadsheets/d/1F4xp1uLQvuUplDPqV_Vg5I-Wp3-7dNlpmY4IQOPTuak/edit#gid=0'),
            SizedBox(
              height: 16,
            ),
            buildName(),
            SizedBox(
              height: 16,
            ),
            buildEmail(),
            SizedBox(
              height: 16,
            ),
            buildPadawan(),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                onPressed: () {},
                child: Text('Save Data')),
            ElevatedButton(
                onPressed: () async {
                  try {
                    insertUsers();
                    Get.snackbar('Sucesso', 'Foi inserido na planilha!');
                  } catch (e) {
                    print('nao foi possivel $e');
                  }
                },
                child: Text('SALVAR DADOS VINDO DE UM JSON')),
          ],
        ),
      ),
    );
  }
}

Widget buildName() => TextFormField(
      controller: nomeController,
      decoration: InputDecoration(
        labelText: 'Nome',
        border: OutlineInputBorder(),
      ),
    );

Widget buildEmail() => TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
    );

Widget buildPadawan() => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    controlAffinity: ListTileControlAffinity.leading,
    value: true,
    title: Text('Voce é Padawan?'),
    onChanged: (value) {});
