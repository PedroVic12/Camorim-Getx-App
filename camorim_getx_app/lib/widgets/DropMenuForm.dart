import 'package:camorim_getx_app/widgets/CaixaDeTexto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropMenuForm extends StatefulWidget {
  DropMenuForm({super.key});

  @override
  State<DropMenuForm> createState() => _DropMenuFormState();
}

class _DropMenuFormState extends State<DropMenuForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> _options = ['Apple', 'Banana', 'Cherry'];
  String? _selectedOption;
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      if (!_options.contains(_textController.text)) {
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
                  controller: _textController,
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
                    _textController.text = newValue!;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          CupertinoButton.filled(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text('Data Processed'),
                    content: Text('Selected: ${_textController.text}'),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('OK'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
