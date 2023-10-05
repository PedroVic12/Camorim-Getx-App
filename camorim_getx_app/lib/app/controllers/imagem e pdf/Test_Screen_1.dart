import 'package:flutter/material.dart';

class TestScreen1 extends StatefulWidget {
  const TestScreen1({super.key});

  @override
  State<TestScreen1> createState() => _TestScreen1State();
}

class _TestScreen1State extends State<TestScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen 1'),
      ),
      body: Column(children: [
        Text('Test Screen 1'),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Pegar imagem da Galeria'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Pegar imagem da Camera'),
        ),
      ]),
    );
  }
}

class RunPythonWidget extends StatefulWidget {
  const RunPythonWidget({super.key});

  @override
  State<RunPythonWidget> createState() => _RunPythonWidgetState();
}

class _RunPythonWidgetState extends State<RunPythonWidget> {
  String output = '';

  void runPythonCode() async {
    //final res = await PythonShell.runScriptAsString(      'path_to_your_python_script.py',      pythonPath: 'path_to_your_python_executable',  // exemplo: /usr/bin/python3 (pode ser opcional dependendo da configuração do sistema)    );

    var res = '';
    setState(() {
      output = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Python e Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: runPythonCode,
              child: Text('Executar Código Python'),
            ),
            SizedBox(height: 20),
            Text('Saída: $output'),
          ],
        ),
      ),
    );
  }
}
