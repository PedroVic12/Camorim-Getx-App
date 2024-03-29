import 'package:camorim_getx_app/app/pages/CRUD%20Excel/excel_sample_crud.dart';
import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:camorim_getx_app/widgets/TableCustom.dart';
import 'package:camorim_getx_app/widgets/table_excel_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThreeFloatingButtons extends StatefulWidget {
  const ThreeFloatingButtons({Key? key}) : super(key: key);

  @override
  _ThreeFloatingButtonsState createState() => _ThreeFloatingButtonsState();
}

class _ThreeFloatingButtonsState extends State<ThreeFloatingButtons>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;
  final CadastroController relatorio_controller =
      Get.find<CadastroController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
    });
    if (_isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isOpen)
          FloatingActionButton(
            onPressed: () {
              // Implemente a ação do primeiro botão aqui
            },
            heroTag: null,
            child: Row(
              children: [Icon(Icons.star), Text("pdf")],
            ),
          ),
        const SizedBox(height: 16),
        if (_isOpen)
          FloatingActionButton(
            splashColor: Colors.blue,
            backgroundColor: Colors.greenAccent,
            onPressed: () {
              // Implemente a ação do segundo botão aqui
              relatorio_controller.salvarDadosCadastradosRelatorio(
                context,
              );
              relatorio_controller.resetLabels();
            },
            heroTag: null,
            child: const Text("Salvar"),
          ),
        const SizedBox(height: 16),
        if (_isOpen)
          FloatingActionButton(
            onPressed: () {
              // Implemente a ação do terceiro botão aqui
              Get.to(EditableTable());
            },
            heroTag: null,
            child: const Icon(Icons.thumb_up),
          ),
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: _toggle,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _controller,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
