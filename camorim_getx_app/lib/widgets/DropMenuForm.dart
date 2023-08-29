import 'package:camorim_getx_app/widgets/CaixaDeTexto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropMenuForm extends StatefulWidget {
  final TextEditingController textController;

  DropMenuForm({required this.textController, super.key});

  @override
  State<DropMenuForm> createState() => _DropMenuFormState();
}

class _DropMenuFormState extends State<DropMenuForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> _options = ['Apple', 'Banana', 'Cherry'];
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    widget.textController.addListener(() {
      if (!_options.contains(widget.textController.text)) {
        _selectedOption = null;
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
                  labelText: 'Entre com as Opções',
                ),
              ),
              SizedBox(width: 16),
              DropdownButton<String>(
                value: _selectedOption,
                hint: const Text('Opções'),
                items: _options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedOption = newValue;
                    widget.textController.text = newValue!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
