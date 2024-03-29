import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';

class Relatorio {
  final String nOS;
  final String barco;
  final String dataInicio;
  final String descFalha;
  final String equipamento;
  final String manutencao;
  final String servExecutado;
  final String oficina;
  final String finalizado;
  final String dataConclusao;
  final String foraOperacao;
  final String obs;

  Relatorio({
    required this.nOS,
    required this.barco,
    required this.dataInicio,
    required this.descFalha,
    required this.equipamento,
    required this.manutencao,
    required this.servExecutado,
    required this.oficina,
    required this.finalizado,
    required this.dataConclusao,
    required this.foraOperacao,
    required this.obs,
  });

  fromJson(json) {
    return Relatorio(
        nOS: json['nOS'],
        barco: json['barco'],
        dataInicio: json['dataInicio'],
        descFalha: json['descFalha'],
        equipamento: json['equipamento'],
        manutencao: json['manutencao'],
        servExecutado: json['servExecutado'],
        oficina: json['oficina'],
        finalizado: json['finalizado'],
        dataConclusao: json['dataConclusao'],
        foraOperacao: json['foraOperacao'],
        obs: json['obs']);
  }
}

class MongoDBController extends GetxController {
  late final Db db;
  final relatorios = <Relatorio>[].obs;
  final url =
      "mongodb+srv://pedrovictorveras:admin@cluster.s1yzg4o.mongodb.net/"
      "?retryWrites=true&w=majority&appName=Cluster";
  @override
  void onInit() {
    super.onInit();
    //var database = conectar();
    //getRelatorios(database);
    //lerTodosDocumentos(database, "relatorio_records");
  }

  conectar() async {
    try {
      final mongo_db = await Db.create(url);
      await mongo_db.open();
      inspect(mongo_db);
      var status = mongo_db.serverStatus();
      print(status);
      final coll = mongo_db.collection('relatorio_records');
      print("\nconexão realizada com sucesso");
      print(coll.find().toList());

      return mongo_db;
    } catch (e) {
      print("Nao conectado! $e");
    }
  }

  Future<void> desconectar() async {
    await db.close();
  }

  Future<void> getRelatorios(_db) async {
    final collection = _db.collection('relatorio_records');
    final documentos = await collection.find().toList();
    print(documentos);
    documentos.forEach((element) {
      relatorios.add(Relatorio(
        nOS: element['nOS'],
        barco: element['barco'],
        dataInicio: element['dataInicio'],
        descFalha: element['descFalha'],
        equipamento: element['equipamento'],
        manutencao: element['manutencao'],
        servExecutado: element['servExecutado'],
        oficina: element['oficina'],
        finalizado: element['finalizado'],
        dataConclusao: element['dataConclusao'],
        foraOperacao: element['foraOperacao'],
        obs: element['obs'],
      ));
    });

    //relatorios.value =        documentos.map((json) => Relatorio.fromJson(json)).toList();
  }

  Future<void> inserirDocumento(
      String collectionName, Map<String, dynamic> documento) async {
    final collection = db.collection(collectionName);
    await collection.insert(documento);
  }

  Future<void> atualizarDocumento(String collectionName,
      Map<String, dynamic> filtro, Map<String, dynamic> atualizacoes) async {
    final collection = db.collection(collectionName);
    await collection.update(filtro, atualizacoes);
  }

  Future<void> deletarDocumento(
      String collectionName, Map<String, dynamic> filtro) async {
    final collection = db.collection(collectionName);
    await collection.remove(filtro);
  }

  Future<Map<String, dynamic>?> lerDocumento(
      String collectionName, Map<String, dynamic> filtro) async {
    final collection = db.collection(collectionName);
    final documento = await collection.findOne(filtro);
    return documento;
  }

  Future<List<Map<String, dynamic>>> lerTodosDocumentos(
      _db, String collectionName) async {
    final collection = _db.collection(collectionName);
    final documentos = await collection.find().toList();
    return documentos;
  }
}
