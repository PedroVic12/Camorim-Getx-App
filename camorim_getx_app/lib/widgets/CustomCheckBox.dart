import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCheckboxGroup extends StatelessWidget {
  final List<String> opcoes;
  final RxList<String> opcaoSelecionada;

  CustomCheckboxGroup({
    required this.opcoes,
    required this.opcaoSelecionada,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: opcoes
            .map((opcao) => CheckboxListTile(
                dense: true,
                title: Text(
                  opcao,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                value: opcaoSelecionada.contains(opcao),
                onChanged: (bool? value) {
                  if (value!) {
                    opcaoSelecionada.add(opcao);
                  } else {
                    opcaoSelecionada.remove(opcao);
                  }
                }))
            .toList(),
      );
    });
  }
}
