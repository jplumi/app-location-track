import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_test/location/location_controller.dart';

class MapScreen extends StatelessWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: controller.getPosition
          )
        ],
      ),
      body: GetBuilder<LocationController>(
        init: LocationController(),
        builder: (controller) => GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(controller.lat.value, controller.lng.value),
            zoom: 16
          ),
          onMapCreated: controller.onMapCreated,
          myLocationEnabled: true,
          markers: controller.markers,
        ),
      )
    );
  }
}