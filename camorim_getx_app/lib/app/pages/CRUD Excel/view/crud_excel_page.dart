import 'package:camorim_getx_app/app/pages/CRUD%20Excel/controllers/excel_controller.dart';
import 'package:camorim_getx_app/app/pages/CRUD%20Excel/model/contact_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../CRUD Google Sheets/GoogleSheetsPage.dart';

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
            title:
                Text(widget.contact == null ? 'Add Contact' : 'Edit Contact')),
        body: ListView(
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.to(GsheetsController);
                },
                child: Text('Google Sheets')),
            Padding(
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
                              name: nameController.text,
                              email: emailController.text);
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
            ),
          ],
        ));
  }
}
