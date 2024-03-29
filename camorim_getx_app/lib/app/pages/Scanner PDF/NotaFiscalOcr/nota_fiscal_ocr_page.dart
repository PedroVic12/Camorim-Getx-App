import 'package:camorim_getx_app/app/pages/Scanner%20PDF/views/widget_extrairTexto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:camorim_getx_app/app/pages/CRUD%20Excel/controllers/excel_controller.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/controller/Ocr_controller_notaFiscal.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/controller/nota_fiscal_controller.dart';
import 'package:camorim_getx_app/app/pages/Scanner%20PDF/controller/servidor_dio_ocr.dart';
import 'package:camorim_getx_app/widgets/CaixaDeTexto.dart';
import 'package:camorim_getx_app/widgets/DropMenuForm.dart';
import 'package:camorim_getx_app/widgets/LoadingWidget.dart';
import 'package:camorim_getx_app/widgets/NavBarCustom.dart';
import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:get/get.dart' as getX;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../../widgets/AppBarPersonalizada.dart';
import '../../CRUD Excel/controllers/bulbassaur_excel.dart';
import '../../OCR_PAGE/views/DadosCadastradosPage.dart';

class NotaFiscalOcrPage extends StatefulWidget {
  const NotaFiscalOcrPage({super.key});

  @override
  State<NotaFiscalOcrPage> createState() => _NotaFiscalOcrPageState();
}

class _NotaFiscalOcrPageState extends State<NotaFiscalOcrPage> {
  XFile? imagemSelecionada;
  String textoExtraido = '';

  //Controllers
  final String baseUrl = 'https://docker-raichu.onrender.com';
  final String cloud_dockerUrl =
      "https://raichu-server-app-247nqx34sa-rj.a.run.app/";
  final String ipAddressDocker = "192.168.3.217:8080";
  final dio_API = ServidorOCR();
  final excel_controller = getX.Get.put(ExcelController());
  final nota_fiscal_controller = getX.Get.put(NotaFiscalController());
  final backendController = OCRController();

  bool imagemEnviada = false;
  int contador = 0;

  @override
  void initState() {
    super.initState();
    //getStatus();

    //Timer.periodic(const Duration(seconds: 120), (timer) => verificaStatus());
  }

  getStatus() async {
    var responseDio = await dio_API.dio.get('$cloud_dockerUrl/');

    print('\nTestando o docker \n${responseDio.data} ');

    return responseDio;
  }

  // Cria a função que será chamada a cada 15 segundos
  void verificaStatus() async {
    // Chama a função `getStatus()`
    var response = await getStatus();

    // Verifica se a resposta foi bem-sucedida
    if (response.statusCode == 200) {
      // Exibe a imagem
      print("\nDocker funcionando: $contador vezes");
      contador++;
    }
  }

  Future<void> lerDadosExtraidos() async {
    var response = await dio_API.dio.get('$cloud_dockerUrl/get-text/');

    if (response.statusCode == 200) {
      try {
        String extractedText = json.encode(response.data);
        print(extractedText);

        Map<String, dynamic> textoExtraido =
            json.decode(extractedText)['texto_extraido'];

        String data = textoExtraido['Data'];

        String local = textoExtraido['Local'];

        List<dynamic> produtos = textoExtraido['Produtos'];

        String total = textoExtraido['Total'];

        // // Remova o símbolo de moeda do total
        total = total.replaceAll('R\$', '');

        //showMessage('Texto', 'Extraído!');
        setState(() {
          nota_fiscal_controller.dataController.text = data;
          nota_fiscal_controller.totalController.text = total;
          nota_fiscal_controller.localController.text = local;
          nota_fiscal_controller.produtosController.text = produtos.join(', ');
        });
      } catch (e) {
        print('\nErro ==  $e');
      }
    }
  }

  Future<void> escolherImagemCamera() async {
    final ImagePicker seletorImagem = ImagePicker();
    final XFile? imagem = await seletorImagem.pickImage(
      source: ImageSource.camera,
      maxHeight: 600,
      maxWidth: 600,
    );

    if (imagem != null) {
      setState(() {
        imagemSelecionada = imagem;
        imagemEnviada = false;
      });

      await sendImageServer(imagemSelecionada!);
    }
  }

  Future<void> escolherImagemGaleria() async {
    try {
      final ImagePicker seletorImagem = ImagePicker();
      final XFile? imagem =
          await seletorImagem.pickImage(source: ImageSource.gallery);

      if (imagem != null) {
        setState(() {
          imagemSelecionada = imagem;
          imagemEnviada = false;
        });

        try {
          await sendImageServer(imagemSelecionada!);
        } catch (e) {
          print('Erro = $e');
        }
      }
    } catch (error) {
      print("\nErro aqui: $error");

      showMessage('Erro', 'Falha ao enviar imagem : $error');
    }
  }

  Future<http.Response> sendImageServer(XFile file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$cloud_dockerUrl/enviar-foto/'),
    );
    request.files.add(
      http.MultipartFile(
        'file', // Este deve ser o nome do campo esperado pelo servidor
        file.readAsBytes().asStream(),
        await file.length(),
        filename: file.name,
      ),
    );
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print("\nResponse status code: ${res.statusCode}");

    if (res.statusCode == 200) {
      print("\nResponse body: " + response.body);

      var responseData = await json.decode(response.body);
      // Access the nested 'ocr_text' object
      String textoExtraido = responseData['ocr_text']?['Data'] ??
          ''; // Get Data or empty string if null

      setState(() {
        this.textoExtraido = textoExtraido;
        imagemEnviada = true;
      });
      showMessage('OK', 'Imagem enviada com sucesso!');
    }

    return response;
  }

  @override
  Widget build(BuildContext context) {
    final bulbassauro = getX.Get.put(BulbassauroExcelController());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 134, 185, 211),
      appBar: AppBarPersonalizada(
        titulo: "Nota Fiscal OCR APP",
      ),
      body: ListView(
        children: [
          //Botoes de Escolha
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: vmStatusServer(
                      "https://i.gifer.com/Td9n.gif"), // Pass the required URL
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data
                          as Widget; // Display the built widget
                    } else {
                      return Container(); // Show loading indicator
                    }
                  },
                ),
                cardButton(
                    escolherImagemGaleria, Icons.photo, "Escolher Imagem"),
                cardButton(
                    escolherImagemCamera, Icons.camera_alt, "Imagem camera"),
              ],
            ),
          ),

          //Exibindo a imagem
          if (imagemSelecionada != null && imagemEnviada == false)
            const Center(child: LoadingWidget())
          else
            Center(child: CardImagem()),

          //Formulario a ser cadastrado
          Column(
            children: [
              selectedForm(),
              CaixaDeTexto(
                  labelText: "Data",
                  controller: nota_fiscal_controller.dataController),
              CaixaDeTexto(
                  labelText: "Total",
                  controller: nota_fiscal_controller.totalController),
              CaixaDeTexto(
                  labelText: "Local",
                  controller: nota_fiscal_controller.localController),
              CaixaDeTexto(
                  labelText: "Produtos",
                  controller: nota_fiscal_controller.produtosController),
            ],
          ),

          BotaoAcao(
              texto: "Salvar Dados Nota Fiscal",
              cor: Colors.green,
              acao: () {
                // String dataFormatada =   DateFormat('dd/MM/yyyy').format(DateTime.now());

                nota_fiscal_controller.salvarDados();

                setState(() {
                  // Reset text fields
                  nota_fiscal_controller.dataController.clear();
                  nota_fiscal_controller.localController.clear();
                  nota_fiscal_controller.produtosController.clear();
                  nota_fiscal_controller.totalController.clear();
                  nota_fiscal_controller.categoriaController.clear();

                  // Reset image
                  imagemSelecionada = null;
                });

                // Show success message
                BulbassauroExcelController().showMessage("Dados Cadastrados!");
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const CustomText(
          text: 'Extrair Texto',
          color: Colors.white,
        ),
        onPressed: lerDadosExtraidos,
        icon: const Icon(Icons.sms_rounded),
        elevation: 10,
        backgroundColor: Colors.indigo,
      ),
      bottomNavigationBar: CustomNavBar(
        navBarItems: [
          NavigationBarItem(
              label: 'OCR',
              iconData: Icons.date_range_outlined,
              onPress: () {
                getX.Get.to(NotaFiscalOcrPage());
              }),
          NavigationBarItem(
              label: 'Dados Cadastrados',
              iconData: Icons.search,
              onPress: () {
                getX.Get.to(DadosCadastradosPage());
              }),
        ],
      ),
    );
  }

  Widget selectedForm() {
    return Column(
      children: [
        DropMenuForm(
          labelText: 'Embarcação',
          options: const [
            'AÇU',
            "ATLÂNTICO",
            'ÁGATA',
            "ALDEBARAN",
            "ALTAIR",
            "ANDREIS XI",
            "ANGRA",
            "ANTARES",
            "ARIES",
            "ARRAIAL",
            "ARTHUR",
            "BALSA CAMORIM",
            "BALSA DIALCAR",
            "BALSA EQUIP 110",
            "BALSA EQUIP 190",
            "EQUIP 180",
            "BRILHANTE",
            "CAMORIM XVII",
            "CARAJAS",
            "CARLA",
            "CETUS",
            "CICLONE",
            "COBRE",
            "CRISTAL",
            "DIAMANTE",
            "EMBARCAÇÃO CASCO 045",
            "EMBARCAÇÃO LOT",
            "ESMERALDA",
            "FELIZ",
            "FLORA",
            "ITACURUÇA",
            "JADE",
            "LANCHA ALUMINA III",
            "LANCHA JAF",
            "LANCHA OCEANBOAT ",
            "LANCHA SAVEIROS TOUR I",
            "LANCHA ST. TROPEZ",
            "LANCHA YECA",
            "LH COMANDANTE",
            "MACAE",
            "MACEIO",
            "MERCURIO IV",
            "MINI OR",
            "MINIBOLA",
            "N ALMEIDA VII",
            "NAVEMAR XIV",
            "NEBLINA",
            "NEVOEIRO",
            "NEW FURACÃO",
            "NEW TROVÃO",
            "NIQUEL",
            "NITEROI",
            "OPALA",
            "ORION",
            "OURO",
            "PEGASUS",
            "PEROLA",
            "PERSIVAL",
            "PRUDENT",
            "QUARTZO",
            "REBOC-CERRAÇÃO(ANT TEXAS)",
            "RELAMPAGO",
            "RIO",
            "SAGA RONCADOR",
            "SAGAMORIM II",
            "SAGITARIUS",
            "SALVADOR",
            "SEPETIBA",
            "SIRIUS",
            "SUPERPESA XIII",
            "SUPERPESA XIV",
            "TITA",
            "TEMPESTADE",
            "TEMPORAL",
            "TOPÁZIO",
            "TORMENTA",
            "TORNADO",
            "TRINDADE",
            "TUFAO",
            "TURMALINA",
            "TURQUEZA",
            "VENDAVAL",
            "VENTANIA",
            "VIGO MAXIMUS",
            "VITORIA",
            "ZANGADO",
          ],
          textController: nota_fiscal_controller.navioController,
        ),
        DropMenuForm(
          labelText: 'Tipo de Despesas',
          options: const [
            'ALUGUEL DE VEÍCULOS',
            'COMBUSTÍVEL',
            "ESTADIAS",
            "CUSTOS DIVERSOS",
            "ESTACIONAMENTO",
            "PEDÁGIO",
            "TRANSPORTE",
            "TRANSPORTE - VIAGENS",
            "ALIMENTAÇÃO - VIAGENS ",
            'CORREIOS',
            "FRETES",
            "MATERIAL DE CONSTRUÇÃO",
            "MATERIAL DE EXPEDIENTE",
            "MATERIAL INFORMÁTICA",
            "MATERIAL MANUT. E REP.",
            "RANCHO DE BORDO",
            "REPRESENTAÇÕES",
            "MANUT. -MAP E EQIP.",
            "MANUT. -PREDIAL",
            "MANUT.-VEICULOS",
            "TELEFONE",
          ],
          textController: nota_fiscal_controller.categoriaController,
        ),
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

  Future<Widget> vmStatusServer(url) async {
    var responseVM = await getStatus();

    // Verifica se a resposta foi bem-sucedida
    if (responseVM.statusCode == 200) {
      return Column(
        children: [
          const CustomText(
            text: 'Maquina virtual online!',
            size: 8,
          ),
          Card(
              child: SizedBox(
            height: 40,
            width: 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(url),
            ),
          ))
        ],
      );
    } else {
      return const CustomText(text: 'Maquina virtual offline! :( ');
    }
  }

  Widget CardImagem() {
    if (imagemSelecionada != null && imagemEnviada == true) {
      return Column(
        children: [
          GestureDetector(
            child: CustomText(
              text: imagemSelecionada!.path,
              size: 10,
            ),
          ),
          SizedBox(
            height: 160,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(imagemSelecionada!.path),
            ),
          )
        ],
      );
    } else {
      return const Center(
        child: CustomText(
          text: 'Nenhuma imagem selecionada',
        ),
      );
    }
  }

  Widget BotaoAcao({
    required String texto,
    required VoidCallback acao,
    Color cor = Colors.blue,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(cor)),
        onPressed: acao,
        child: CustomText(
          text: texto,
          color: Colors.white,
          size: 16,
          weight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget cardTextoEditavel(
      String labelText, TextEditingController _controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Digite algo aqui...',
          border: const OutlineInputBorder(),
          label: Text(
            labelText,
            style: const TextStyle(
              color: Colors.purple,
            ),
          ),
        ),
        maxLines: null, // Permite múltiplas linhas
        keyboardType: TextInputType.multiline,
      ),
    );
  }

  Widget CardTexto() {
    return Container(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomText(text: textoExtraido),
      ),
    );
  }

  void showMessage(String texto1, String texto2) async {
    getX.Get.snackbar(texto1, texto2, snackPosition: getX.SnackPosition.TOP);
  }
}
