import 'dart:io';

import 'package:camorim_getx_app/api/Raichu_api.dart';
import 'package:camorim_getx_app/app/controllers/imagem%20e%20pdf/files_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widgets/customText.dart';

class PegandoArquivosPage extends StatefulWidget {
  @override
  State<PegandoArquivosPage> createState() => _PegandoArquivosPageState();
}

class _PegandoArquivosPageState extends State<PegandoArquivosPage> {
  final FilesController controller = Get.put(FilesController());
  final RaichuRestApi raichu_api = Get.put(RaichuRestApi());

  Future<void> pegarImagem() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selectedImage = File(image.path);
        setState(() {
          controller.pickedImage.value = selectedImage as Image?;
        });
      } else {
        print('Nenhuma imagem selecioanda');
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var f = await image.readAsBytes();

        setState(() {
          controller.webImage = f;
          controller.pickedImage.value = f as Image?;
        });
      } else {
        print('Nenhuma imagem selecioanda');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: controller.pegarUmArquivo,
          child: Text('Selecione um arquivo'),
        ),
        Obx(() {
          Uint8List? imagemBytes = controller.imagemBytes.value;
          return imagemBytes != null
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.memory(imagemBytes),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: imagemBytes != null
                          ? () async {
                              try {
                                await raichu_api.uploadImage(imagemBytes);
                                // Mostrando uma SnackBar em caso de sucesso
                                Get.snackbar(
                                  "Sucesso",
                                  "Imagem enviada com sucesso!",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              } catch (e) {
                                // Mostrando uma SnackBar em caso de erro
                                Get.snackbar(
                                  "Erro",
                                  "Falha ao enviar a imagem: $e",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            }
                          : null, // Desabilitando o botão se imagemBytes for null
                      child: Text('Upload Image'),
                    ),
                  ],
                )
              : Text('Insira uma imagem...');
        }),
      ],
    );
  }

  Widget cardButton(function, IconData icone, String texto) {
    return InkWell(
      onTap: function,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 100,
          width: 160,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(icone), CustomText(text: texto)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DisplayFilesWidget extends StatelessWidget {
  final FilesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Arquivos Selecionados")),
      body: Obx(
        () => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: controller.selectedFiles.length,
          itemBuilder: (context, index) {
            final file = controller.selectedFiles[index];
            return GestureDetector(
              onTap: () => controller.abrirArquivo(file.path!),
              onLongPress: () {
                if (['jpg', 'jpeg', 'png'].contains(file.extension)) {
                  //controller.salvarImagemLocalmente(file.bytes!, file.name);
                }
              },
              child: Card(
                child: GridTile(
                  child: _buildFilePreview(file),
                  footer: GridTileBar(
                    backgroundColor: Colors.black45,
                    title: Text(file.extension!),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilePreview(PlatformFile file) {
    if (['jpg', 'jpeg', 'png'].contains(file.extension)) {
      return Image.memory(
        file.bytes!,
        fit: BoxFit.cover,
      );
    } else {
      return Center(
        child: Text(
          file.name,
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
