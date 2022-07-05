import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_test/screens/home.dart';

void main() {
  runApp(const MapTestApp());
}

class MapTestApp extends StatelessWidget {
  const MapTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MapTest',
      home: Home(),
    );
  }
}
