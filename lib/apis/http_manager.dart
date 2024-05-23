import 'dart:collection';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:life_berg/model/user/user_response.dart';

import '../model/base_response.dart';
import '../model/error/error_response.dart';
import '../model/reminder/reminder_date_time.dart';
import 'apis_constants.dart';

class HttpManager {
  BaseResponse _getErrorResponse(String data) {
    var responseBody = json.decode(data);
    ErrorResponse errorResponse = ErrorResponse.fromJson(responseBody);
    return BaseResponse(errorResponse, null);
  }

  Future<BaseResponse> signUp(
      String fullName, String email, String password, String fcmToken) async {
    try {
      var url = ApiConstants.SIGNUP;

      var params = HashMap();
      params["email"] = email;
      params["fullName"] = fullName;
      params["password"] = password;
      params["fcmToken"] = fcmToken;

      var response =
          await http.post(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
      });
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        UserResponse userResponse = UserResponse.fromJson(responseBody);
        return BaseResponse(userResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> login(
      String email, String password, String fcmToken) async {
    try {
      var url = ApiConstants.LOGIN;

      var params = HashMap();
      params["email"] = email;
      params["password"] = password;
      params["fcmToken"] = fcmToken;

      var response =
          await http.post(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
      });
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        UserResponse userResponse = UserResponse.fromJson(responseBody);
        return BaseResponse(userResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> socialLogin(
      String email, String socialType, String name) async {
    try {
      var url = ApiConstants.SOCIAL_LOG_IN;
      var params = HashMap();
      params["email"] = email;
      params["socialType"] = socialType;
      params["fullName"] = name;
      var response =
          await http.post(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        UserResponse userResponse = UserResponse.fromJson(responseBody);
        return BaseResponse(userResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> forgotPasswordStepOne(String email) async {
    try {
      var url = ApiConstants.FORGOT_PASS_STEP_ONE;
      var params = HashMap();
      params["email"] = email;
      var response =
          await http.post(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        return BaseResponse(true, null);
      } else {
        return BaseResponse(false, null);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> forgotPasswordStepTwo(String email, String code) async {
    try {
      var url = ApiConstants.FORGOT_PASS_STEP_TWO;
      var params = HashMap();
      params["email"] = email;
      params["OTP"] = code;
      var response =
          await http.post(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        return BaseResponse(true, null);
      } else {
        return BaseResponse(false, null);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> forgotPasswordStepThree(
      String email, String code, String password) async {
    try {
      var url = ApiConstants.FORGOT_PASS_STEP_THREE;
      var params = HashMap();
      params["email"] = email;
      params["password"] = password;
      params["forgotPasswordNonce"] = code;
      var response =
          await http.post(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        return BaseResponse(true, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> addNewGoal(String token, String icon,
      String name,
      String category,
      String description,
      String noOfDays,
      String daysType,
      String importanceScale,
      bool isScale,
      String color,
      List<ReminderDateTime> timesList) async {
    try {
      var url = ApiConstants.ADD_GOAL;
      var params = HashMap();
      params["icon"] = icon;
      params["name"] = name;
      params["category"] = "6638bf06584bab76b306e569";
      params["description"] = description;
      params["color"] = color;
      params["measureType"] = isScale ? "string" : "boolean";
      params["achieveXDays"] = noOfDays;
      params["achieveType"] = daysType;
      params["goalImportance"] = importanceScale;
      List<Map<String,String>> reminderList = [];
      for(var reminder in timesList){
        HashMap<String, String> timeMap = HashMap();
        timeMap["day"] = reminder.day;
        timeMap["time"] = DateFormat("HH:mm").format(reminder.time);
        reminderList.add(timeMap);
      }
      params["reminders"] = reminderList;

      var response = await http.post(Uri.parse(url),
          body: json.encode(params),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        UserResponse userResponse = UserResponse.fromJson(responseBody);
        return BaseResponse(userResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> updateUser(String token, String userId,
      {String? country,
      String? iceberg,
      String? username,
      String? primaryVocation}) async {
    try {
      var url = ApiConstants.UPDATE_USER;
      var params = HashMap();
      if (country != null) {
        params["country"] = country;
      }
      if (iceberg != null) {
        params["lifeBergName"] = iceberg;
      }
      if (username != null) {
        params["userName"] = username;
      }
      if (primaryVocation != null) {
        params["primaryVocation"] = primaryVocation;
      }

      var response = await http.put(Uri.parse(url),
          body: json.encode(params),
          headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        UserResponse userResponse = UserResponse.fromJson(responseBody);
        return BaseResponse(userResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }
}
