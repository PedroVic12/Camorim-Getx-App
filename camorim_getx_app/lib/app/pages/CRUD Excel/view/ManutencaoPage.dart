import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/views/cadastro_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/excel_controller.dart';

class ManutencaoPage extends StatefulWidget {
  const ManutencaoPage({super.key});

  @override
  State<ManutencaoPage> createState() => _ManutencaoPageState();
}

class _ManutencaoPageState extends State<ManutencaoPage> {
  final emailController = TextEditingController();
  final controller = Get.put(ExcelController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          emailPrencher(),
          customFormulario(),
        ]),
      ),
    );
  }

  Widget emailPrencher() {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(labelText: 'Email'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter email';
            }
            return null;
          },
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Salvar'),
        ),
      ],
    );
  }

  Widget customFormulario() {
    final CadastroController relatorio_controller =
        Get.put(CadastroController());

    return Obx(() {
      final model = relatorio_controller.currentModel.value;
      final models = relatorio_controller.array_cadastro;
      if (model != null) {
        return Column(
          children: models
              .map((element) => Card(
                  color: Colors.blueGrey,
                  child: ListTile(
                    title: Text(element.equipamento),
                    subtitle: Column(
                      children: [
                        Text(
                          element.rebocador,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          element.acao,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        models.remove(element);
                      },
                    ),
                  )))
              .toList(),
        );
      } else {
        return Text('Sem dados cadastrados :(');
      }
    });
  }
}
