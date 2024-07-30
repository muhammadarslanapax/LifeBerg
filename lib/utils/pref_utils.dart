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

  String get user => _sharedPreferences!.getString(userDetail) ?? "";

  set user(String value) {
    _sharedPreferences!.setString(userDetail, value);
  }

  String get userId => _sharedPreferences!.getString(id) ?? "";

  set userId(String value) {
    _sharedPreferences!.setString(id, value);
  }

  String get token => _sharedPreferences!.getString(userToken) ?? "";

  set token(String value) {
    _sharedPreferences!.setString(userToken, value);
  }

  bool get loggedIn => _sharedPreferences!.getBool(isLoggedIn) ?? false;

  set loggedIn(bool value) {
    _sharedPreferences!.setBool(isLoggedIn, value);
  }

  String get submittedGoals => _sharedPreferences!.getString(goalData) ?? "";

  set submittedGoals(String value) {
    _sharedPreferences!.setString(goalData, value);
  }

  bool get isGoalSubmittedToday =>
      _sharedPreferences!.getBool(goalSubmit) ?? false;

  set isGoalSubmittedToday(bool value) {
    _sharedPreferences!.setBool(goalSubmit, value);
  }

  String get getSkippedGoals =>
      _sharedPreferences!.getString(skippedGoals) ?? "";

  set setSkippedGoals(String value) {
    _sharedPreferences!.setString(skippedGoals, value);
  }

  String get lastSavedDate => _sharedPreferences!.getString(savedDate) ?? "";

  set lastSavedDate(String value) {
    _sharedPreferences!.setString(savedDate, value);
  }

  String get newGoalStartTime =>
      _sharedPreferences!.getString(newDayTime) ?? "02:00 AM";

  set newGoalStartTime(String value) {
    _sharedPreferences!.setString(newDayTime, value);
  }

  String get isNewDataLoaded => _sharedPreferences!.getString(lastDate) ?? "";

  set isNewDataLoaded(String value) {
    _sharedPreferences!.setString(lastDate, value);
  }

  String get tomorrowHighlightGoal =>
      _sharedPreferences!.getString(tomorrowHighlight) ?? "";

  set tomorrowHighlightGoal(String value) {
    _sharedPreferences!.setString(tomorrowHighlight, value);
  }

  String get tomorrowHighlightGoalDate =>
      _sharedPreferences!.getString(tomorrowHighlightDate) ?? "";

  set tomorrowHighlightGoalDate(String value) {
    _sharedPreferences!.setString(tomorrowHighlightDate, value);
  }

  String get savedMood => _sharedPreferences!.getString(lastSavedMood) ?? "";

  set savedMood(String value) {
    _sharedPreferences!.setString(lastSavedMood, value);
  }

  String get lastGratefulText =>
      _sharedPreferences!.getString(lastSavedGrateful) ?? "";

  set lastGratefulText(String value) {
    _sharedPreferences!.setString(lastSavedGrateful, value);
  }

  String get lastLearntText =>
      _sharedPreferences!.getString(lastSavedLearnt) ?? "";

  set lastLearntText(String value) {
    _sharedPreferences!.setString(lastSavedLearnt, value);
  }

  String get lastHighlightText =>
      _sharedPreferences!.getString(lastSavedHighlight) ?? "";

  set lastHighlightText(String value) {
    _sharedPreferences!.setString(lastSavedHighlight, value);
  }
}
