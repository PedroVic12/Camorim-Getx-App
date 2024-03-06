import 'package:mongo_dart/mongo_dart.dart';

class DataBaseMongoDB {
  late Db db;
  final dataBase = 'Relatorio_OS_DB';
  final get_collection = "relatorio_records";

  DataBaseMongoDB(String uri) {
    db = Db(uri);
  }

  Future<void> connect() async {
    await db.open();
    print('Conectado ao banco de dados MongoDB');
  }

  Future<void> criarDocumento(
      Map<String, dynamic> documento, String collection) async {
    await db.collection(collection).insert(documento);
    print('Documento criado com sucesso');
  }

  Future<void> deletarDocumento(
      Map<String, dynamic> filtro, String collection) async {
    await db.collection(collection).remove(filtro);
    print('Documento deletado com sucesso');
  }

  Future<List<Map<String, dynamic>>> recuperarTodosDocumentos(
      String collection) async {
    var result = await db.collection(collection).find().toList();
    return result.map((doc) => doc as Map<String, dynamic>).toList();
  }

  Future<void> close() async {
    await db.close();
    print('Conexão com o banco de dados fechada');
  }
}
