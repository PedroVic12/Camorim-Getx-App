import 'package:camorim_getx_app/widgets/TextLabel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RadioButtonGroup extends StatelessWidget {
  final List<String> niveis;
  final RxString nivelSelecionado;

  RadioButtonGroup({
    required this.niveis,
    required this.nivelSelecionado,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Card(
        color: Colors.white70,
        child: Column(
          children: niveis
              .map((nivel) => RadioListTile(
                  dense: true,
                  title: TextLabel(texto: nivel),
                  value: nivel,
                  selected: nivelSelecionado.value == nivel,
                  groupValue: nivelSelecionado.value,
                  onChanged: (value) {
                    nivelSelecionado.value = value.toString();
                  }))
              .toList(),
        ),
      );
    });
  }
}
