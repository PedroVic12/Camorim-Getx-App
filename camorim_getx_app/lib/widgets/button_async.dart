import 'package:flutter/material.dart';

class ButtonAsyncState extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  final String text;
  final bool isLoading;
  ButtonAsyncState(
      {super.key,
      required this.onPressed,
      required this.iconData,
      required this.text,
      required this.isLoading});

  @override
  State<ButtonAsyncState> createState() => _ButtonAsyncStateState();
}

class _ButtonAsyncStateState extends State<ButtonAsyncState> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
      ),
      child: widget.isLoading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(width: 10), // Espaçamento entre o ícone e o texto
                Text(widget.text),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.iconData),
                SizedBox(width: 10), // Espaçamento entre o ícone e o texto
                Text(widget.text),
              ],
            ),
    );
  }
}
