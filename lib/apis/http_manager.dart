import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:life_berg/model/action_plan/action_plan_list_response.dart';
import 'package:life_berg/model/generic_response.dart';
import 'package:life_berg/model/goal/goals_list_response.dart';
import 'package:life_berg/model/goal_mood_report/goal_date_response.dart';
import 'package:life_berg/model/goal_report/goal_report_list_response.dart';
import 'package:life_berg/model/journal/journal_list_response.dart';
import 'package:life_berg/model/mood_history/mood_history_response.dart';
import 'package:life_berg/model/user/user_response.dart';
import 'package:mime/mime.dart';

import '../model/base_response.dart';
import '../model/error/error_response.dart';
import '../model/goal/goal.dart';
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

  Future<BaseResponse> addNewGoal(
      String token,
      String icon,
      String name,
      String category,
      String description,
      String noOfDays,
      String daysType,
      String importanceScale,
      bool isScale,
      // String color,
      List<ReminderDateTime> timesList) async {
    try {
      var url = ApiConstants.ADD_GOAL;
      Map<String, dynamic> params = {
        "icon": icon,
        "name": name,
        "category": category,
        "description": description,
        "measureType": isScale ? "string" : "boolean",
        "achieveXDays": noOfDays,
        "achieveType": daysType,
        "goalImportance": importanceScale,
        "reminders": timesList.map((reminder) {
          return {
            "day": reminder.day,
            "time": DateFormat("HH:mm").format(reminder.time)
          };
        }).toList()
      };

      var response =
          await http.post(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse genericResponse =
            GenericResponse.fromJson(responseBody);
        return BaseResponse(genericResponse, null);
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
      String? primaryVocation,
      String? fullName,
      String? dob}) async {
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

      if (fullName != null) {
        params["fullName"] = fullName;
      }

      if (dob != null) {
        params["dob"] = dob;
      }

      var response =
          await http.put(Uri.parse(url), body: json.encode(params), headers: {
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

  Future<BaseResponse> getCurrentUserDetail(
    String token,
  ) async {
    try {
      var url = ApiConstants.GET_CURRENT_USER_DETAIL;
      var response = await http.get(Uri.parse(url), headers: {
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

  Future<BaseResponse> updateUserImageFromAsset(
      String token, String userId, String assetImage) async {
    try {
      var url = ApiConstants.UPDATE_USER;
      var request = http.MultipartRequest("PUT", Uri.parse(url));
      request.fields["userId"] = userId;
      final tempFile = await createTempFileFromAsset(assetImage);

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        tempFile.path,
        contentType: MediaType.parse(
            lookupMimeType(tempFile.path) ?? 'application/octet-stream'),
      ));

      request.headers.addAll({
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      });
      var response = await request.send();
      final res = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        var responseBody = json.decode(res.body);
        UserResponse userResponse = UserResponse.fromJson(responseBody);
        return BaseResponse(userResponse, null);
      } else {
        return _getErrorResponse(res.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<File> createTempFileFromAsset(String imagePath) async {
    final byteData = await rootBundle.load(imagePath);
    final tempDir = Directory.systemTemp;
    final tempFile =
        File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await tempFile.writeAsBytes(byteData.buffer.asUint8List());
    return tempFile;
  }

  Future<BaseResponse> updateUserImage(
      String token, String userId, XFile file) async {
    try {
      var url = ApiConstants.UPDATE_USER;
      var request = http.MultipartRequest("PUT", Uri.parse(url));
      request.fields["userId"] = userId;
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType.parse(
            lookupMimeType(file.path) ?? 'application/octet-stream'),
      ));

      // request.files.add(await http.MultipartFile.fromPath('file', file.path,));
      request.headers.addAll({
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      });
      var response = await request.send();
      final res = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        var responseBody = json.decode(res.body);
        UserResponse userResponse = UserResponse.fromJson(responseBody);
        return BaseResponse(userResponse, null);
      } else {
        return _getErrorResponse(res.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> updateUserMood(
      String token, int mood, String comment) async {
    try {
      var url = ApiConstants.SUBMIT_MOOD;
      var params = HashMap();
      params["date"] = DateTime.now().toUtc().toIso8601String();
      params["mood"] = mood;
      params["comment"] = comment;
      var response =
          await http.post(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse genericResponse =
            GenericResponse.fromJson(responseBody);
        return BaseResponse(genericResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> getUserGoalsList(
    String token,
    String status,
  ) async {
    try {
      var url = ApiConstants.GOAL_LIST;
      var request = http.Request(
        'GET',
        Uri.parse(url),
      )..headers.addAll({
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        });
      var params = {
        "status": status,
      };
      request.body = jsonEncode(params);
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();
        var responseBody = json.decode(value);
        GoalsListResponse goalsListResponse =
            GoalsListResponse.fromJson(responseBody);
        return BaseResponse(goalsListResponse, null);
      } else {
        var value = await response.stream.bytesToString();
        return _getErrorResponse(value);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> deleteGoal(String token, String goalId) async {
    try {
      var url = ApiConstants.DELETE_GOAL;
      var params = HashMap();
      params["goal"] = goalId;
      var response = await http
          .delete(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse genericResponse =
            GenericResponse.fromJson(responseBody);
        return BaseResponse(genericResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> addCommentOnGoal(
      String token, String goalId, String comment) async {
    try {
      var url = ApiConstants.UPDATE_GOAL;
      var params = HashMap();
      params["goalId"] = goalId;
      params["comment"] = comment;
      var response =
          await http.put(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse genericResponse =
            GenericResponse.fromJson(responseBody);
        return BaseResponse(genericResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> updateGoalStatus(
      String token, String goalId, String status) async {
    try {
      var url = ApiConstants.UPDATE_GOAL;
      var params = HashMap();
      params["goalId"] = goalId;
      params["status"] = status;
      var response =
          await http.put(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse genericResponse =
            GenericResponse.fromJson(responseBody);
        return BaseResponse(genericResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> editGoal(
      String token,
      String goalId,
      String icon,
      String name,
      String category,
      String description,
      String noOfDays,
      String daysType,
      String importanceScale,
      bool isScale,
      // String color,
      List<ReminderDateTime> timesList) async {
    try {
      var url = ApiConstants.UPDATE_GOAL;
      Map<String, dynamic> params = {
        "goalId": goalId,
        "icon": icon,
        "name": name,
        "category": category,
        "description": description,
        "measureType": isScale ? "string" : "boolean",
        "achieveXDays": noOfDays,
        "achieveType": daysType,
        "goalImportance": importanceScale,
        "reminders": timesList.map((reminder) {
          return {
            "day": reminder.day,
            "time": DateFormat("HH:mm").format(reminder.time)
          };
        }).toList()
      };

      var response =
          await http.put(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse genericResponse =
            GenericResponse.fromJson(responseBody);
        return BaseResponse(genericResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> deleteUserProfilePicture(
    String token,
  ) async {
    try {
      var url = ApiConstants.DELETE_PROFILE_PIC;

      var response = await http.delete(Uri.parse(url), headers: {
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

  Future<BaseResponse> addNewJournal(
    String token,
    String description,
    String color,
    String category,
  ) async {
    try {
      var url = ApiConstants.ADD_JOURNAL;
      Map<String, dynamic> params = {
        "color": color,
        "description": description,
        "category": category,
      };

      var response =
          await http.post(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse genericResponse =
            GenericResponse.fromJson(responseBody);
        return BaseResponse(genericResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> getJournals(
    String token,
  ) async {
    try {
      var url = ApiConstants.JOURNAL_LIST;

      var response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        JournalListResponse journalListResponse =
            JournalListResponse.fromJson(responseBody);
        return BaseResponse(journalListResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> deleteJournal(String token, String journalId) async {
    try {
      var url = ApiConstants.DELETE_JOURNAL;
      var params = HashMap();
      params["journalId"] = journalId;
      var response = await http
          .delete(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse genericResponse =
            GenericResponse.fromJson(responseBody);
        return BaseResponse(genericResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> updateJournal(
    String token,
    String journalId,
    String description,
    String color,
  ) async {
    try {
      var url = ApiConstants.UPDATE_JOURNAL;
      Map<String, dynamic> params = {
        "color": color,
        "description": description,
        "journalId": journalId,
      };

      var response =
          await http.put(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse genericResponse =
            GenericResponse.fromJson(responseBody);
        return BaseResponse(genericResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> submitGoalReport(
    String token,
    String highlight,
    List<Goal> goal,
  ) async {
    try {
      var url = ApiConstants.SUBMIT_GOAL;
      Map<String, dynamic> params = {
        "date": DateTime.now().toUtc().toIso8601String(),
        if (highlight.isNotEmpty) "highLight": highlight,
        "details": goal.map((e) {
          return {
            "type": e.goalMeasure!.type,
            "value": e.goalMeasure!.type == "string"
                ? e.sliderValue.value.toInt().toString()
                : e.isChecked.value,
            "goal": e.sId!,
            "comment": e.comment ?? ""
          };
        }).toList(),
      };

      var response =
          await http.post(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse genericResponse =
            GenericResponse.fromJson(responseBody);
        return BaseResponse(genericResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> getAllGoalReports(
    String token,
  ) async {
    try {
      var url = ApiConstants.GET_ALL_GOALS_REPORT;

      var response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GoalReportListResponse goalReportListResponse =
            GoalReportListResponse.fromJson(responseBody);
        return BaseResponse(goalReportListResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> getGoalReport(String token, String goalId) async {
    try {
      var url = ApiConstants.GET_GOAL_REPORT;

      var request = http.Request(
        'GET',
        Uri.parse(url),
      )..headers.addAll({
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        });
      var params = {
        "goal": goalId,
      };
      request.body = jsonEncode(params);
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();
        var responseBody = json.decode(value);
        GoalReportListResponse goalReportListResponse =
            GoalReportListResponse.fromJson(responseBody);
        return BaseResponse(goalReportListResponse, null);
      } else {
        var value = await response.stream.bytesToString();
        return _getErrorResponse(value);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> getAllMoodHistory(
    String token,
  ) async {
    try {
      var url = ApiConstants.GET_ALL_MOOD_HISTORY;

      var response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        MoodHistoryResponse moodHistoryResponse =
            MoodHistoryResponse.fromJson(responseBody);
        return BaseResponse(moodHistoryResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> getUserActionPlan(
    String token,
  ) async {
    try {
      var url = ApiConstants.GET_ACTION_PLANS;

      var response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        ActionPlanListResponse actionPlanListResponse =
            ActionPlanListResponse.fromJson(responseBody);
        return BaseResponse(actionPlanListResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> addNewActionPlan(
    String token,
    String title,
    String category,
  ) async {
    try {
      var url = ApiConstants.CREATE_ACTION_PLAN;
      Map<String, dynamic> params = {
        "name": title,
        "actionCategory": category,
      };

      var response =
          await http.post(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse genericResponse =
            GenericResponse.fromJson(responseBody);
        return BaseResponse(genericResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> deleteActionPlan(String token, String actionId) async {
    try {
      var url = ApiConstants.DELETE_ACTION_PLAN;
      var params = HashMap();
      params["actionPlan"] = actionId;
      var response = await http
          .delete(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse genericResponse =
            GenericResponse.fromJson(responseBody);
        return BaseResponse(genericResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> updateActionPlan(
    String token,
    String actionPlanId,
    String title,
    String category,
  ) async {
    try {
      var url = ApiConstants.UPDATE_ACTION_PLAN;
      Map<String, dynamic> params = {
        "actionPlan": actionPlanId,
        "name": title,
        "category": category,
      };

      var response =
          await http.put(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse genericResponse =
            GenericResponse.fromJson(responseBody);
        return BaseResponse(genericResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> resetPassword(
    String token,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      var url = ApiConstants.RESET_PASSWORD;
      var params = HashMap();

      params["password"] = currentPassword;
      params["newPassword"] = newPassword;

      var response =
          await http.put(Uri.parse(url), body: json.encode(params), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse genericResponse =
            GenericResponse.fromJson(responseBody);
        return BaseResponse(genericResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> getGoalReportByDate(String token, String date) async {
    try {
      var url = ApiConstants.DATE_GOAL_REPORT;

      var request = http.Request(
        'GET',
        Uri.parse(url),
      )..headers.addAll({
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        });
      var params = {
        "date": date,
      };
      request.body = jsonEncode(params);
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();
        var responseBody = json.decode(value);
        GoalDateResponse goalDateResponse =
        GoalDateResponse.fromJson(responseBody);
        return BaseResponse(goalDateResponse, null);
      } else {
        var value = await response.stream.bytesToString();
        return _getErrorResponse(value);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }

  Future<BaseResponse> getTopStreak(
    String token,
  ) async {
    try {
      var url = ApiConstants.TOP_STREAK;

      var response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        GenericResponse genericResponse =
        GenericResponse.fromJson(responseBody);
        return BaseResponse(genericResponse, null);
      } else {
        return _getErrorResponse(response.body);
      }
    } catch (e) {
      return BaseResponse(null, e.toString());
    }
  }
}
