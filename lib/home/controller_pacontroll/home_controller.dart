import 'package:get/get.dart';

class HomeController extends GetxController {
  static final HomeController instance = HomeController._internal();

  HomeController._internal();

  var _curentIndex = 0.obs;

  updateCurentIndex(value) => _curentIndex.value = value;

  get curentIndex => _curentIndex.value;
}
