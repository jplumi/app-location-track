import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {

  final lat = 0.0.obs;
  final lng = 0.0.obs;

  late GoogleMapController _mapsController;
  late StreamSubscription<Position>? positionStream;
  late StreamSubscription? vehiclesStream;

  final _firestore = FirebaseFirestore.instance;

  final markers = Set<Marker>().obs;

  @override
  void onClose() {
    positionStream?.cancel();
    vehiclesStream?.cancel();
    _mapsController.dispose();
    super.onClose();
  }

  onMapCreated(GoogleMapController mapController) {
    _mapsController = mapController;
    loadMapStyle();
    watchPosition();
    _mapsController.animateCamera(CameraUpdate.newLatLng(const LatLng(-27.6349, -52.2737)));
    // loadMarkers();
    startListeningToVehicles();
  }

  loadMapStyle() async {
    String mapStyle = await rootBundle.loadString('assets/map_style.txt');
    _mapsController.setMapStyle(mapStyle);
  }

  void watchPosition() async {
    positionStream = Geolocator.getPositionStream().listen((Position position) {
      if(position != null) {
        lat.value = position.latitude;
        lng.value = position.longitude;
        update();
      }
    });
  }

  void loadMarkers() {
    markers.addAll([
      const Marker(
        markerId: MarkerId("1"),
        position: LatLng(-27.6399, -52.2798),
        infoWindow: InfoWindow(title: 'Ponto1'),
      ),
      const Marker(
        markerId: MarkerId("2"),
        position: LatLng(-27.6379, -52.2742),
      ),
    ]);
    update();
  }

  Future _getCurrentLocation() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission locationPermission;

    if(!isEnabled) {
      return Future.error('Por favor, abilite a localização do telefone');
    }

    locationPermission = await Geolocator.checkPermission();
    if(locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if(locationPermission == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização.');
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error('Autorize o acesso à localização nas configurações.');
    }

    return await Geolocator.getCurrentPosition();
  }

  getPosition() async {
    try {
      final position = await _getCurrentLocation();
      lat.value = position.latitude;
      lng.value = position.longitude;
      _mapsController.animateCamera(CameraUpdate.newLatLng(LatLng(lat.value, lng.value)));
    } catch (e) {
      Get.snackbar(
        'Erro',
        e.toString(),
        backgroundColor: Colors.grey[900],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void startListeningToVehicles() {
    final collection = _firestore.collection('transports');
    vehiclesStream = collection.snapshots()
      .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
        final docs = snapshot.docChanges;
        for(DocumentChange<Map<String, dynamic>> doc in docs) {
          final data = doc.doc.data()!;
          final docId = doc.doc.id;
          final latitude = data['latitude'];
          final longitude = data['longitude'];
          markers.add(Marker(
            markerId: MarkerId(docId),
            position: LatLng(latitude, longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(
              title: 'Carro',
              snippet: docId
            )
          ));
          update();
        }
      },);
  }
}