import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_test/screens/map_screen.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Card(
                child: ListTile(
                  title: const Text('Ver o mapa'),
                  leading: const Icon(Icons.map),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Get.to(() => MapScreen());
                  },
                ),
              ),
              // StreamBuilder<QuerySnapshot>(
              //   stream: fireStore.collection('transports').snapshots(),
              //   builder: (context, snapshot) {
              //     if(!snapshot.hasData) {
              //       return const Center(child: CircularProgressIndicator());
              //     }

              //     final docs = snapshot.data!.docChanges;

              //     for(var doc in docs) {
              //       print(doc.doc.data());
              //     }

              //     return Container();
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }

}
