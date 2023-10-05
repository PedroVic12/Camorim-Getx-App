import 'package:flutter/material.dart';

class AppBarPersonalizada extends StatelessWidget
    implements PreferredSizeWidget {
  final String titulo;

  AppBarPersonalizada({required this.titulo});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          titulo,
          style: TextStyle(color: Colors.deepOrange, fontSize: 20),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 17, 46, 99),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.black,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      elevation: 5, // Para adicionar sombra
    );
  }
}
