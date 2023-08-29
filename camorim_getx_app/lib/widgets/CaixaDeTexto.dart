import 'package:flutter/material.dart';

class CaixaDeTexto extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isReadOnly;
  final Function()? onTap;
  final double? height; // Adicione o parâmetro opcional

  CaixaDeTexto({
    required this.controller,
    required this.labelText,
    this.isReadOnly = false,
    this.onTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextField(
          style: TextStyle(),
          controller: controller,
          readOnly: isReadOnly,
          onTap: onTap,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.purple[50],
            border: OutlineInputBorder(),
            label: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0), // Seu valor de padding
              child: Text(
                labelText,
                style: const TextStyle(
                  color: Colors.purple,
                ),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: (height ?? 48.0) / 2 - 12,
            ),
          )),
    );
  }
}
