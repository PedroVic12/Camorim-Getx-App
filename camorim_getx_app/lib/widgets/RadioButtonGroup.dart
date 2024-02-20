import 'package:camorim_getx_app/widgets/TextLabel.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RadioButtonGroup extends StatelessWidget {
  final List<String> niveis;
  final RxString nivelSelecionado;
  final String textLabel;

  RadioButtonGroup({
    required this.niveis,
    required this.nivelSelecionado,
    required this.textLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: 60,
        decoration: BoxDecoration(
          color: const Color.fromARGB(121, 255, 255, 255),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomText(
              text: textLabel,
              size: 20,
              color: Colors.black,
              weight: FontWeight.bold,
            ),
            ...niveis
                .map(
                  (nivel) => RadioListTile(
                    dense: true,
                    title: TextLabel(texto: nivel, size: 10),
                    value: nivel,
                    selected: nivelSelecionado.value == nivel,
                    groupValue: nivelSelecionado.value,
                    onChanged: (value) {
                      nivelSelecionado.value = value.toString();
                    },
                  ),
                )
                .toList(),
          ],
        ),
      );
    });
  }
}
