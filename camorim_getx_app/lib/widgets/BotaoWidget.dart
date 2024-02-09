import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BotaoPadrao extends StatelessWidget {
  final Color color;
  final VoidCallback on_pressed;
  final String text;
  BotaoPadrao(
      {super.key,
      required this.color,
      required this.on_pressed,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
            height: 40,
            child: ElevatedButton(
                onPressed: on_pressed,
                style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ))));
  }
}
