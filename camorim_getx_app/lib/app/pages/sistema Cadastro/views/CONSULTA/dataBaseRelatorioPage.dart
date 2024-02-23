import 'dart:convert';

import 'package:camorim_getx_app/app/pages/sistema%20Cadastro/cadastro_controllers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as DioApp;
import 'package:http/http.dart' as http;

class DataBaseRelatorioConsultaPage extends StatelessWidget {
  const DataBaseRelatorioConsultaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CadastroController());

    print(controller.relatorio_array.length);

    return Container(
      color: Colors.grey,
      height: MediaQuery.of(context)
          .size
          .height, // Definindo a altura para ocupar toda a tela
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Obx(() {
            if (controller.relatorio_array.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.relatorio_array.length == 0) {
              return const Center(
                child: Text("Nenhum dado encontrado"),
              );
            }

            return ListView.builder(
              shrinkWrap:
                  true, // Garante que o ListView não expanda infinitamente
              itemCount: controller.relatorio_array.length,
              itemBuilder: (context, index) {
                final object = controller.relatorio_array[index];
                return Card(
                  child: ListTile(
                    title: Text(object.rebocador),
                    subtitle: Text(object.dataInicial),
                    trailing: Text(object.status_finalizado.value),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
