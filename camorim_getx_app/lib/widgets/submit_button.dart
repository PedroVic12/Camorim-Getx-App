import 'package:camorim_getx_app/controllers/Formulario/FormController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitButton extends StatelessWidget {
  final FormController formController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.yellow),
        elevation: MaterialStateProperty.all(10),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.yellow))),
      ),
      onPressed: () {
        if (formController.validateFormData()) {
          print('Nome ferramenta: ${formController.nomeController.text}');
          print('Data de retirada: ${formController.dataNascimento}');
          print(formController.opcaoSelecionada);
          print(formController.quantidade);
          print(formController.nivelSelecionado);
          print(formController.salarioEscolhido);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Text('Cadastrar dados'),
      ),
    );
  }
}
