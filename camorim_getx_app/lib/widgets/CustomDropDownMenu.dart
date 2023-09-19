import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/controllers/Formulario/FormController.dart';

class CustomDropDownMenu extends StatelessWidget {
  final FormController formController = Get.find();

  List<DropdownMenuItem<int>> returnItens(int quantidadeMaxima) {
    var itens = <DropdownMenuItem<int>>[];
    for (var i = 1; i <= quantidadeMaxima; ++i) {
      itens.add(DropdownMenuItem(
        child: Center(
            child: Text(i.toString(),
                style: TextStyle(color: CupertinoColors.activeBlue))),
        value: i,
      ));
    }
    return itens;
  }

  CustomDropDownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Center(
        child: CupertinoPopupSurface(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: CupertinoColors.darkBackgroundGray,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: 150,
            height: 60,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                dropdownColor: CupertinoColors.systemGrey6,
                icon: Icon(CupertinoIcons.down_arrow,
                    color: CupertinoColors.activeBlue),
                style:
                    TextStyle(color: CupertinoColors.activeBlue, fontSize: 25),
                value: formController.quantidade.value,
                isExpanded: true,
                isDense: true,
                items: returnItens(10),
                onChanged: (value) {
                  print(value);
                  formController.quantidade.value = value!;
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
