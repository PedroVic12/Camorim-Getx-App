import 'package:flutter/material.dart';

class TextLabel extends StatelessWidget {
  final String texto;
  final Color cor;
  final double size;
  const TextLabel(
      {super.key,
      required this.texto,
      this.cor = Colors.black,
      this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Text(texto,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ));
  }
}
