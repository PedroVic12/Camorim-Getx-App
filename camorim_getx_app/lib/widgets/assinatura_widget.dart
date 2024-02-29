import 'dart:html';

import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class AssinaturaWidget extends StatelessWidget {
  AssinaturaWidget({super.key});

  GlobalKey<SfSignaturePadState> _assinaturaKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: Column(
        children: [
          SfSignaturePad(
            key: _assinaturaKey,
            backgroundColor: Colors.white30,
            strokeColor: Colors.blue,
            minimumStrokeWidth: 4.0,
            maximumStrokeWidth: 6.0,
          ),
          Row(
            children: [
              TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () {},
                  child: CustomText(
                    text: "Clear",
                  )),
              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue.shade300)),
                  onPressed: () {},
                  child: CustomText(
                    text: "Salvar",
                  )),
            ],
          )
        ],
      ),
    );
  }
}
