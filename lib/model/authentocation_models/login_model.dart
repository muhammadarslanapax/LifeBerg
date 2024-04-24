class LoginModel {
  bool? success;
  Data? data;
  String? message;
  String? token;
  String? fcmToken;

  LoginModel(
      {this.success, this.data, this.message, this.token, this.fcmToken});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    token = json['token'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['token'] = this.token;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}

class Data {
  String? sId;
  String? socialType;
  String? firstName;
  String? lastName;
  String? email;
  String? forgotPasswordNonce;
  String? password;
  bool? pushNotification;
  bool? emailNotification;
  String? filePath;
  String? fcmToken;

  Data(
      {this.sId,
        this.socialType,
        this.firstName,
        this.lastName,
        this.email,
        this.forgotPasswordNonce,
        this.password,
        this.pushNotification,
        this.emailNotification,
        this.filePath,
        this.fcmToken});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    socialType = json['socialType'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    forgotPasswordNonce = json['forgotPasswordNonce'];
    password = json['password'];
    pushNotification = json['pushNotification'];
    emailNotification = json['emailNotification'];
    filePath = json['filePath'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['socialType'] = this.socialType;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['forgotPasswordNonce'] = this.forgotPasswordNonce;
    data['password'] = this.password;
    data['pushNotification'] = this.pushNotification;
    data['emailNotification'] = this.emailNotification;
    data['filePath'] = this.filePath;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}