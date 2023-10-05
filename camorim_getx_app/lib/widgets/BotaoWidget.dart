import 'package:flutter/material.dart';

class BotaoWidget extends StatelessWidget {
  final VoidCallback btnPressionado;
  final MaterialStateProperty<Color?> cor;
  final String text;
  BotaoWidget(
      {super.key,
      required this.btnPressionado,
      required this.cor,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: cor,
          elevation: MaterialStateProperty.all<double?>(10),
        ),
        onPressed: btnPressionado,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
