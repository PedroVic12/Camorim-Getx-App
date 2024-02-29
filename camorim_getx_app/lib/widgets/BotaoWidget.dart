import 'package:camorim_getx_app/widgets/customText.dart';
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
                child: CustomText(
                  text: text,
                  size: 16,
                  color: Colors.white,
                  weight: FontWeight.bold,
                ))));
  }
}
