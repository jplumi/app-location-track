import 'package:get/get.dart';

class TesteController extends GetxController {
  var count = 0.obs;

  increment() {
    count++;
  }

}