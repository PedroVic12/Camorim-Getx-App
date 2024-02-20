import 'package:flutter/material.dart';

class CaixaDeTexto extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String labelText;
  final TextStyle labelStyle;
  final double? height; // Adicione o parâmetro opcional
  final Function()? onTap;

  const CaixaDeTexto({
    Key? key,
    required this.controller,
    this.focusNode,
    required this.labelText,
    this.height,
    this.onTap,
    this.labelStyle = const TextStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onTap: onTap,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.purple[50],
          border: OutlineInputBorder(),
          label: Padding(
            padding: const EdgeInsets.only(left: 12.0), // Seu valor de padding
            child: Text(
              labelText,
              style: const TextStyle(
                color: Colors.purple,
                fontSize: 16,
              ),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
              vertical: (height ?? 10.0), horizontal: 10.0),
        ),
      ),
    );
  }
}
