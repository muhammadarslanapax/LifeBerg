import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesForUser {
  final SharedPreferences _prefs;

  SharedPreferencesForUser._(this._prefs);

  static SharedPreferencesForUser? _instance;

  static Future<SharedPreferencesForUser> getInstance() async {
    if (_instance == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _instance = SharedPreferencesForUser._(prefs);
    }
    return _instance!;
  }

  Future<void> setLoggedIn(bool isLoggedIn) {
    return _prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> setToken(String token) {
    return _prefs.setString('token', token);
  }

  Future<void> setFirstName(String firstName) {
    return _prefs.setString('firstName', firstName);
  }

  Future<void> setLastName(String lastName) {
    return _prefs.setString('lastName', lastName);
  }

  Future<void> setEmail(String email) {
    return _prefs.setString('email', email);
  }

  Future<void> setGoogleId(String id) {
    return _prefs.setString('googleId', id);
  }

  Future<void> setAppleId(String id) {
    return _prefs.setString('appleId', id);
  }

  Future<void> setUserID(String userID) {
    return _prefs.setString('userID', userID);
  }

  bool isLoggedIn() {
    return _prefs.getBool('isLoggedIn') ?? false;
  }

  String getToken() {
    return _prefs.getString('token') ?? "";
  }

  String getFirstName() {
    return _prefs.getString('firstName') ?? '';
  }

  String getLastName() {
    return _prefs.getString('lastName') ?? '';
  }

  String getEmail() {
    return _prefs.getString('email') ?? "";
  }

  String getGoogleId() {
    return _prefs.getString('googleId') ?? "";
  }

  String getAppleId() {
    return _prefs.getString('appleId') ?? "";
  }

  String getUserID() {
    return _prefs.getString('userID') ?? "";
  }

}