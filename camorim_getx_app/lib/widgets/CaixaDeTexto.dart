import 'package:flutter/material.dart';

class CaixaDeTexto extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isReadOnly;
  final Function()? onTap;

  CaixaDeTexto({
    required this.controller,
    required this.labelText,
    this.isReadOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextField(
        controller: controller,
        readOnly: isReadOnly,
        onTap: onTap,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.purple[50], // Cor de fundo roxa clara
          border: OutlineInputBorder(),
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.purple), // Cor de texto roxa
        ),
      ),
    );
  }
}
