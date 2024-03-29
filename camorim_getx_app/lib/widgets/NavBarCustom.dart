import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final List<NavigationBarItem> navBarItems;

  CustomNavBar({required this.navBarItems});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.indigoAccent,
      items: navBarItems.map((item) {
        // Crie uma cópia personalizada do BottomNavigationBarItem
        return BottomNavigationBarItem(
          icon: Icon(item.iconData),
          label: item.label,
        );
      }).toList(),
      onTap: (index) {
        // Chame a função onPress do item selecionado
        navBarItems[index].onPress();
      },
    );
  }
}

class NavigationBarItem {
  final String label;
  final IconData iconData;
  final Function onPress;

  NavigationBarItem({
    required this.label,
    required this.iconData,
    required this.onPress,
  });
}

class CustomLabel extends StatelessWidget {
  final String label;
  final Color textColor;

  CustomLabel({required this.label, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(color: textColor),
    );
  }
}
