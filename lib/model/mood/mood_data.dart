import 'package:get/get_rx/src/rx_types/rx_types.dart';

class RxMoodData {
  RxString emoji;
  RxInt value;

  RxMoodData({
    required String emoji,
    required int value,
  })  : emoji = emoji.obs,
        value = value.obs;
}
