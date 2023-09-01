import 'package:camorim_getx_app/widgets/CaixaDeTexto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropMenuForm extends StatefulWidget {
  final TextEditingController textController;
  final String labelText;
  final List<String> options;

  DropMenuForm({
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
        title: const Text('Selecione uma Opção'),
        children: widget.options.map((String option) {
          return SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, option);
            },
            child: Text(option),
          );
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
                child: CaixaDeTexto(
                  controller: widget.textController,
                  labelText: widget.labelText,
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: _showOptionsDialog,
                child: const CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Icon(
                    Icons.arrow_circle_down,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
