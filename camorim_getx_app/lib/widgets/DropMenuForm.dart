import 'package:flutter/material.dart';
import 'package:camorim_getx_app/widgets/customText.dart';

class DropMenuForm extends StatefulWidget {
  final TextEditingController textController;
  final String labelText;
  final List<String> options;

  const DropMenuForm({
    Key? key,
    required this.textController,
    required this.labelText,
    required this.options,
  }) : super(key: key);

  @override
  State<DropMenuForm> createState() => _DropMenuFormState();
}

class _DropMenuFormState extends State<DropMenuForm> {
  String selectedValue = "";

  @override
  void initState() {
    super.initState();
    // Adiciona um ouvinte ao textController para reagir a mudanças.
    widget.textController.addListener(_updateSelectedValueFromController);
  }

  @override
  void dispose() {
    // Remove o ouvinte quando o widget for desmontado para evitar vazamentos de memória.
    widget.textController.removeListener(_updateSelectedValueFromController);
    super.dispose();
  }

  // Atualiza o selectedValue baseado no valor atual do textController.
  void _updateSelectedValueFromController() {
    if (selectedValue != widget.textController.text) {
      setState(() {
        selectedValue = widget.textController.text;
      });
    }
  }

  Future<void> _showOptionsDialog() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text("Selecione uma Opção:"),
        children: widget.options.map((String option) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, option),
            child: Text(option),
          );
        }).toList(),
      ),
    );

    if (selected != null) {
      setState(() {
        selectedValue = selected;
        widget.textController.text = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return widget.options.where((String option) => option
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (String selection) {
                setState(() {
                  selectedValue = selection;
                  widget.textController.text = selection;
                });
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                // Synchronize the field controller with the state's text controller on rebuild
                fieldTextEditingController.text = selectedValue;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.purple[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      label: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0), // Seu valor de padding
                        child: Text(
                          widget.labelText,
                          style: const TextStyle(
                            color: Colors.purple,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: (10.0), horizontal: (10.0)),
                    ),
                  ),
                );
              },
            ),
            Positioned(
                right: 4,
                top: 0,
                bottom: 0,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _showOptionsDialog,
                      icon: const CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Icon(
                          Icons.arrow_circle_down,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    )
                  ],
                )),
          ],
        ),
      ],
    );
  }
}
