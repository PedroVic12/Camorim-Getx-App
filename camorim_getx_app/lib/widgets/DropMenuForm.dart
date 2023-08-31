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
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    widget.textController.addListener(() {
      if (!widget.options.contains(widget.textController.text)) {
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
                  labelText: widget.labelText,
                ),
              ),
              const SizedBox(width: 12),
              Theme(
                  data: Theme.of(context).copyWith(
                      popupMenuTheme: const PopupMenuThemeData(),
                      canvasColor: Colors.indigo),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth:
                                50, // ajuste este valor conforme necessário
                          ),
                          child: DropdownButton<String>(
                            value: _selectedOption,
                            icon: Center(
                                child: Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedOption = newValue;
                                widget.textController.text = newValue!;
                              });
                            },
                            items: widget.options.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            selectedItemBuilder: (BuildContext context) {
                              return widget.options.map<Widget>((String value) {
                                return const SizedBox
                                    .shrink(); // Retornamos um widget vazio para que não seja exibido nada quando a opção estiver selecionada
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
