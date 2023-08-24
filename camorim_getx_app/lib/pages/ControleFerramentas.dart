import 'package:camorim_getx_app/widgets/Caixa_texto.dart';
import 'package:camorim_getx_app/widgets/CustomCheckBox.dart';
import 'package:camorim_getx_app/widgets/CustomDropDownMenu.dart';
import 'package:camorim_getx_app/widgets/RadioButtonGroup.dart';
import 'package:camorim_getx_app/widgets/TextLabel.dart';
import 'package:camorim_getx_app/widgets/submit_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/Formulario/FormController.dart';

class ControleFerramentasPage extends StatefulWidget {
  const ControleFerramentasPage({super.key});

  @override
  State<ControleFerramentasPage> createState() =>
      _ControleFerramentasPageState();
}

class _ControleFerramentasPageState extends State<ControleFerramentasPage> {
  final formController = Get.put(FormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CupertinoColors.activeBlue,
        title: Center(child: Text('Controle de Ferramentas')),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: ListView(
            children: [
              TextLabel(
                texto: 'Oficina Elétrica',
              ),

              RadioButtonGroup(
                niveis: formController.niveis,
                nivelSelecionado: formController.nivelSelecionado,
              ),

              // Formulario
              CaixaDeTexto(
                controller: formController.nomeController,
                labelText: "Nome do Funcionario",
              ),
              CaixaDeTexto(
                controller: formController.ferramentaController,
                labelText: 'Ferramenta',
              ),
              CaixaDeTexto(
                controller: formController.localController,
                labelText: 'Local da Ferramenta',
              ),

              TextLabel(texto: 'Quantidade de peças'),
              CustomDropDownMenu(),

              // Data de Cadastro
              CaixaDeTexto(
                controller: formController.dataNascimentoController,
                labelText: 'Data de Cadastro',
                onTap: () async {
                  var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1990),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) {
                    formController.dataNascimentoController.text =
                        date.toIso8601String();
                    formController.dataNascimento.value = date;
                  }
                },
              ),

              // Checkbox
              TextLabel(texto: 'Serviço Finalizado??'),
              CustomCheckboxGroup(
                opcoes: formController.opcoes,
                opcaoSelecionada: formController.opcaoSelecionada,
              ),

              TextLabel(texto: 'STATUS FERRAMENTA'),
              //todo verificar se possui essa ferramenta no estoque
              //todo se sim, mostrar a quantidade disponivel
              //todo se não, mostrar que não possui

              // Slider
              Obx(() => TextLabel(
                  texto:
                      "Pretensão Salarial: ${formController.salarioEscolhido.value.round().toString()} reais")),
              Slider(
                min: 0,
                max: 15000,
                value: formController.salarioEscolhido.value,
                onChanged: (double value) {
                  setState(() {
                    formController.salarioEscolhido.value = value;
                  });
                },
              ),

              // Botão de envio
              SubmitButton()
            ],
          ),
        ),
      ),
    );
  }
}
