import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;

  const GlassCard({
    Key? key,
    required this.child,
    this.width = 200,
    this.height = 200,
  }) : super(key: key);

  @override
  _GlassCardState createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GlassContainer(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 1,
        ),
        gradient: LinearGradient(colors: [
          Colors.white.withOpacity(0.2),
          Colors.lightBlueAccent.withOpacity(0.12),
          Colors.white.withOpacity(0.2),
        ]),
        blur: 25,
        //borderRadius: BorderRadius.circular(50),
        width: widget.width,
        height: widget.height,
        child: widget.child,
      ),
    );
  }
}

// Exemplo de uso:
class ExampleUsage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Glassmorphism Example'),
      ),
      body: Container(
        color: Colors.black45,
        child: const GlassCard(
          width: 300,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                size: 50,
                color: Colors.red,
              ),
              SizedBox(height: 10),
              Text(
                'Glassmorphism UI',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
