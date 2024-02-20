import 'package:camorim_getx_app/widgets/CaixaDeTexto.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropMenuForm extends StatefulWidget {
  final TextEditingController textController;
  final String labelText;
  final List<String> options;

  const DropMenuForm({
    required this.textController,
    required this.labelText,
    required this.options,
    Key? key,
  }) : super(key: key);

  @override
  State<DropMenuForm> createState() => _DropMenuFormState();
}

class _DropMenuFormState extends State<DropMenuForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _showOptionsDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Column(children: [
          Divider(),
          CustomText(
            text: "Selecione uma Opção: ",
            size: 20,
            color: Colors.blue,
          ),
          Divider()
        ]),
        children: widget.options.map((String option) {
          return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, option);
              },
              child: CustomText(text: option));
        }).toList(),
      ),
    ).then((selectedValue) {
      if (selectedValue != null && selectedValue.isNotEmpty) {
        setState(() {
          widget.textController.text = selectedValue;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: caixaTextoAutoComplete(),
              ),
              InkWell(
                onTap: _showOptionsDialog,
                child: const CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Icon(
                    Icons.arrow_circle_down,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          )
        ],
      ),
    );
  }

  Widget caixaTextoAutoComplete() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return widget.options.where((option) =>
            option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (String selectedOption) {
        setState(() {
          widget.textController.text =
              selectedOption; // Atualiza o campo de texto
        });
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return CaixaDeTexto(
          controller: widget
              .textController, // Assegura que o controller seja compartilhado
          focusNode: focusNode,
          labelText: widget.labelText,
          // Outros parâmetros necessários para CaixaDeTexto
        );
      },
    );
  }
}
