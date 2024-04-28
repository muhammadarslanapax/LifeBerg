import 'package:shared_preferences/shared_preferences.dart';

import '../constant/pref_keys.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  factory PrefUtils() => PrefUtils._internal();

  PrefUtils._internal();

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  bool get getIsShowIntro => _sharedPreferences!.getBool(introShow) ?? true;

  set setIsShowIntro(bool value) {
    _sharedPreferences!.setBool(introShow, value);
  }
}
