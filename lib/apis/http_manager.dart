import 'dart:collection';
import 'dart:convert';

import 'package:life_berg/model/authentocation_models/login_model.dart';
import 'package:life_berg/model/authentocation_models/signup_model.dart';
import 'package:http/http.dart' as http;

import '../model/base_response.dart';
import 'apis_constants.dart';

class HttpManager {

  Future<BaseResponse> signUp(
      String firstName,
      String secondName,
      String email,
      String password,
      String fcmToken) async {
    try {
      var url = ApiConstants.SIGNUP;

      var params = HashMap();
      params["email"] = email;
      params["firstName"] = firstName;
      params["lastName"] = secondName;
      params["password"] = password;
      params["fcmToken"] = fcmToken;

      var response = await http.post(Uri.parse(url), body: params);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        SignupModel registrationMethod = SignupModel.fromJson(responseBody);
        return BaseResponse(registrationMethod, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> loginUp(
      String email,
      String password,
      String fcmToken) async {
    try {
      var url = ApiConstants.LOGIN;

      var params = HashMap();
      params["email"] = email;
      params["password"] = password;
      params["fcmToken"] = fcmToken;

      var response = await http.post(Uri.parse(url), body: params);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        LoginModel loginModel = LoginModel.fromJson(responseBody);
        return BaseResponse(loginModel, null);
      } else {
        return BaseResponse(null, response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

}
