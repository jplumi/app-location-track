import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:map_test/teste/teste_controller.dart';
import 'package:map_test/screens/map_screen.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final TesteController controller = Get.put(TesteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: controller.increment
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Card(
                child: ListTile(
                  title: Text('Ver o mapa'),
                  leading: Icon(Icons.map),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Get.to(MapScreen());
                  },
                ),
              ),
              Center(
                child: Obx(() => Text('${controller.count}')),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
