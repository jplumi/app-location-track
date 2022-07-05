import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {

  final lat = 0.0.obs;
  final lng = 0.0.obs;

  late GoogleMapController _mapsController;
  late StreamSubscription<Position> positionStream;
  final markers = Set<Marker>();

  onMapCreated(GoogleMapController mapController) {
    _mapsController = mapController;
    loadMapStyle();
    getPosition();
    _mapsController.animateCamera(CameraUpdate.newLatLng(const LatLng(-27.6355, -52.2733)));
    loadMarkers();
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
  }

  @override
  void onClose() {
    if(positionStream != null) {
      positionStream.cancel();
    }
    _mapsController.dispose();
    super.onClose();
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

}