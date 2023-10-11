import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/relatorios/RelatorioController.dart';

class DisplaySimpleForms extends StatelessWidget {
  DisplaySimpleForms({super.key});
  final RelatorioController controller = Get.put(RelatorioController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller.nomeRebocadorText,
          decoration: InputDecoration(
            hintText: 'Nome do Rebocador',
            labelText: 'Nome do Rebocador',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            isDense: true,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller.descricaoFalhaText,
          decoration: InputDecoration(
            hintText: 'Descrição da falha',
            labelText: 'Descrição da Falha',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            isDense: true,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller.servicoExecutadoText,
          decoration: InputDecoration(
            hintText: 'Serviço Executado',
            labelText: 'Serviço Executado',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            isDense: true,
          ),
        ),
        SizedBox(height: 8),
        Text('Serviço Finalizado?'),
        Checkbox(
          value: controller.servicoFinalizado.value,
          onChanged: (value) {
            controller.servicoFinalizado.value = value!;
          },
        ),
      ],
    );
  }
}

class DisplayFormsResults extends StatelessWidget {
  final RelatorioController controller = Get.put(RelatorioController());

  DisplayFormsResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            controller.addRelatorio();
          },
          child: Text("Enviar "),
        ),
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemCount: controller.relatorio.length,
              itemBuilder: (context, index) {
                final relatorioItem = controller.relatorio[index];
                return ListTile(
                  title: Text(relatorioItem.nome_rebocador!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(relatorioItem.descricao_falha!),
                      Text(relatorioItem.servico_executado!),
                      Text(
                        'Serviço Finalizado: ${relatorioItem.servico_finalizado}',
                      ),
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      controller.removerRelatoio(index);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
