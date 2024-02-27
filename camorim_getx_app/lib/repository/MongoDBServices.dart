import 'package:mongo_dart/mongo_dart.dart';

class MongoDBService {
  late Db _db;

  MongoDBService() {
    _connectToDatabase();
  }

  Future<void> _connectToDatabase() async {
    try {
      _db = await Db.create('mongodb://localhost:27017/my_database');
      await _db.open();
      print('Connected to MongoDB');
    } catch (e) {
      print('Error connecting to MongoDB: $e');
    }
  }

  Future<void> insertData(Map<String, dynamic> data) async {
    try {
      await _db.collection('my_collection').insert(data);
      print('Data inserted successfully');
    } catch (e) {
      print('Error inserting data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      final data = await _db.collection('my_collection').find().toList();
      return data.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}

class DataEditor {
  final MongoDBService mongoDBService = MongoDBService();

  Future<void> editData(Map<String, dynamic> newData) async {
    // Implemente a lógica para editar os dados no banco de dados MongoDB
  }

  Future<void> deleteData(String id) async {
    // Implemente a lógica para excluir os dados no banco de dados MongoDB
  }
}
