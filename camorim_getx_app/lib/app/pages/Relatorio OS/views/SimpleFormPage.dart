import 'package:camorim_getx_app/app/pages/Relatorio%20OS/widgets/relatorios_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SimpleFormsPage extends StatefulWidget {
  const SimpleFormsPage({super.key});

  @override
  State<SimpleFormsPage> createState() => _SimpleFormsPageState();
}

class _SimpleFormsPageState extends State<SimpleFormsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Forms'),
      ),
      body: Column(
        children: [
          DisplaySimpleForms(),
          DisplayFormsResults(),
          Center(
            child: Text('Simple Forms'),
          ),
        ],
      ),
    );
  }
}
