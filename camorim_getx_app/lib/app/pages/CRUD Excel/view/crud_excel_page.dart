import 'package:camorim_getx_app/app/pages/CRUD%20Excel/controllers/excel_controller.dart';
import 'package:camorim_getx_app/app/pages/CRUD%20Excel/model/contact_model.dart';
import 'package:camorim_getx_app/widgets/CaixaDeTexto.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../sistema Cadastro/cadastro_controllers.dart';
import '../../sistema Cadastro/views/cadastro_page.dart';

class ContactForm extends StatefulWidget {
  final Contact?
      contact; // Null para novo contato, preenchido para editar um contato existente

  ContactForm({this.contact});

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final controller = Get.put(ExcelController());
  final CadastroController relatorio_controller = Get.put(CadastroController());

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      nameController.text = widget.contact!.name;
      emailController.text = widget.contact!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              widget.contact == null ? 'CRUD EXCEL PAGE' : 'Edit Contact')),
      body: ListView(
        children: [
          FormsListRelatorio(),
          cardsProdutosCadastrados(),
          // saveExcelExemplo()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          relatorio_controller.salvar(
            context,
          );
        },
        child: Text('SALVAR!'),
      ),
    );
  }

  Widget saveExcelExemplo() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
            ),
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Adicione ou atualize o contato usando o ContactController
                  final contact = Contact(
                      name: nameController.text, email: emailController.text);
                  controller.addContact(
                      contact); // Aqui você pode decidir adicionar ou atualizar com base em widget.contact
                  Get.back();
                }
              },
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }

  Widget cardsProdutosCadastrados() {
    return Obx(() {
      final model = relatorio_controller.currentModel.value;
      final models = relatorio_controller.array_cadastro;
      if (model != null) {
        return Column(
          children: models
              .map((element) => Card(
                  color: Colors.lightBlue,
                  child: ListTile(
                    title: Text(element.equipamento),
                    subtitle: Column(
                      children: [
                        Text(
                          element.rebocador,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          element.dataInicial,
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

class FormsListRelatorio extends StatelessWidget {
  final CadastroController relatorio_controller = Get.put(CadastroController());
  FormsListRelatorio({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CaixaDeTexto(
            controller: relatorio_controller.EQUIPAMENTO_TEXT,
            labelText: 'EQUIPAMENTO'),
        CaixaDeTexto(
            controller: relatorio_controller.nomeRebocadorText,
            labelText: 'REBOCADOR'),
        CaixaDeTexto(
            controller: relatorio_controller.ACAOTEXT,
            labelText: 'DESCRIÇÃO DA AÇÃO'),
        CaixaDeTexto(
            controller: relatorio_controller.STATUSTEXT, labelText: 'STATUS'),
        CaixaDeTexto(
            controller: relatorio_controller.GRUPO, labelText: 'GRUPO'),
      ],
    );
  }
}
