// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GoogleMapsController extends GetxController {
  final google_api_key = "AIzaSyBz5PufcmSRVrrmTWPHS2qlzPosL70XrwE";

  @override
  void onReady() {
    setInitialLocation();
    setDestinationLocation();
  }

  void getPolyPoints() async {
  }

  void setInitialLocation() async {
    final sourceLatLng =
        await getLatLngFromAddress('Seu endereço inicial', google_api_key);
    print(sourceLatLng);
    // Use sourceLatLng para adicionar um marcador ao mapa
  }

  void setDestinationLocation() async {
    final destinationLatLng =
        await getLatLngFromAddress('Seu endereço de destino', google_api_key);
    print(destinationLatLng);
  }

  Future<LatLng> getLatLngFromAddress(String address, String apiKey) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final location = jsonResponse['results'][0]['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    } else {
      throw Exception('Erro ao buscar localização: ${response.body}');
    }
  }
}
