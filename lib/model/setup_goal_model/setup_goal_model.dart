import 'package:get/get.dart';

class ToggleButtonModel {
  final String text;
  RxBool isSelected = false.obs;

  ToggleButtonModel({
    required this.text,
    required this.isSelected,
  });
}
