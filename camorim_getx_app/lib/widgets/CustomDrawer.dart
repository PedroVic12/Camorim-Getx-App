import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: Column(children: [
        UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.blue, child: Icon(Icons.photo)),
            accountName: Text('Pedro'),
            accountEmail: Text('camorim.com')),
        Divider(),
        SizedBox(height: 10),
      ]),
    );
  }
}
