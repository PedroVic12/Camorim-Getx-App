import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/pages/Scanner PDF/first_page.dart';
import '../app/pages/Scanner PDF/second_page.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue, child: Icon(Icons.photo)),
            accountName: Text('Pedro'),
            accountEmail: Text('camorim.com')),
        InkWell(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            width: double.infinity,
            child: const Row(
              children: [
                Icon(Icons.pages),
                SizedBox(width: 5),
                Text('Primeira Pagina'),
              ],
            ),
          ),
          onTap: () {
            Get.back();
            Get.to(PrimeiraPagina());
          },
        ),
        const Divider(),
        const SizedBox(height: 10),
        InkWell(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            width: double.infinity,
            child: const Row(
              children: [
                Icon(Icons.pages),
                SizedBox(width: 5),
                Text('Segunda Pagina'),
              ],
            ),
          ),
          onTap: () {
            Get.back();
            Get.to(Secondpage());
          },
        )
      ]),
    );
  }
}
