import 'package:life_berg/model/user/user.dart';

class UserResponse {
  bool? success;
  User? user;
  String? message;
  String? token;
  String? fcmToken;

  UserResponse(
      {this.success, this.user, this.message, this.token, this.fcmToken});

  UserResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    user = json['data'] != null ? new User.fromJson(json['data']) : null;
    message = json['message'];
    token = json['token'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.user != null) {
      data['data'] = this.user!.toJson();
    }
    data['message'] = this.message;
    data['token'] = this.token;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}