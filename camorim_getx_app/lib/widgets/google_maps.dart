import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart'
    as googleMaps;

class PedidoTrackingMapsScreen extends StatefulWidget {
  const PedidoTrackingMapsScreen({super.key});

  @override
  State<PedidoTrackingMapsScreen> createState() =>
      _PedidoTrackingMapsScreenState();
}

class _PedidoTrackingMapsScreenState extends State<PedidoTrackingMapsScreen> {
  final google_api_key = "AIzaSyBz5PufcmSRVrrmTWPHS2qlzPosL70XrwE";
  late Completer<googleMaps.GoogleMapController> googleMapController =
      Completer();

// Dados
  static const LatLng sourceLocation = LatLng(37.22300926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);



//variaveis
  bool showMaps = true;
  List<Marker> marker_array = [];

  @override
  void initState() {
    super.initState();
    marker_array.add(
      const Marker(
        markerId: MarkerId('source'),
        position: sourceLocation,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    if (marker_array.isNotEmpty) {
      setState(() {
        showMaps = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Google Maps web'),
        ),
        body: GoogleMap(
          // mapType: MapType.normal,
          initialCameraPosition:
              const CameraPosition(target: sourceLocation, zoom: 13.5),

          markers: {
            const Marker(
              markerId: MarkerId('source'),
              position: sourceLocation,
              icon: BitmapDescriptor.defaultMarker,
            ),
            const Marker(
              markerId: MarkerId('destination'),
              position: destination,
              icon: BitmapDescriptor.defaultMarker,
            ),
          },
        ),
      );
    } else {
      return const Center(
        child: Text('Executando em um dispositivo móvel'),
      );
    }
  }

  Widget buildMapContainer() {
    return Padding(
        padding: EdgeInsets.all(12),
        child: showMaps
            ? Container(
                height: 300,
                width: 1200,
                child: GoogleMap(
                  mapType: MapType.terrain,
                  initialCameraPosition:
                      CameraPosition(target: sourceLocation, zoom: 13.5),
                  onMapCreated: (controller) {
                    setState(() {
                      googleMapController = controller
                          as Completer<googleMaps.GoogleMapController>;
                    });
                  },
                  markers: Set<Marker>.of(marker_array),
                ),
              )
            : CircularProgressIndicator());
  }
}
