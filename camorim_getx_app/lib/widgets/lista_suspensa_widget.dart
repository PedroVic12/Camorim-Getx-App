import 'package:flutter/material.dart';

class Item {
  final String option;
  bool selected;

  Item(this.option, this.selected);
}

class ListaSuspensaCheckBox extends StatefulWidget {
  ListaSuspensaCheckBox({super.key});

  @override
  State<ListaSuspensaCheckBox> createState() => _ListaSuspensaCheckBoxState();
}

class _ListaSuspensaCheckBoxState extends State<ListaSuspensaCheckBox> {
  // Lista de itens do formulário
  final List<Item> items = [];

  final List<String> options = ['Opção 1', 'Opção 2', 'Opção 3'];

  // Item selecionado na lista suspensa
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // Lista suspensa
          DropdownButtonFormField<String>(
            value: selectedOption,
            items: options
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedOption = value;
              });
            },
          ),
          // Checkbox
          CheckboxListTile(
            title: Text(selectedOption ?? ''),
            value: items
                .any((item) => item.option == selectedOption && item.selected),
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  final item =
                      items.map((item) => item.option == selectedOption);
                  if (item != null) {
                  } else {
                    items.add(Item(selectedOption!, value));
                  }
                }
              });
            },
          ),
          // Lista de itens com botões de remoção
          ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Text(items[index].option),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        items.removeAt(index);
                      });
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
