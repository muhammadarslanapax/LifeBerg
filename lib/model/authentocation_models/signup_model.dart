class SignupModel {
  bool? success;
  Data? data;
  String? message;
  String? token;
  String? fcmToken;

  SignupModel(
      {this.success, this.data, this.message, this.token, this.fcmToken});

  SignupModel.fromJson(Map<String, dynamic> json) {
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
  String? socialType;
  String? firstName;
  String? lastName;
  String? email;
  bool? pushNotification;
  bool? emailNotification;
  String? filePath;
  String? fcmToken;
  String? sId;

  Data(
      {this.socialType,
        this.firstName,
        this.lastName,
        this.email,
        this.pushNotification,
        this.emailNotification,
        this.filePath,
        this.fcmToken,
        this.sId});

  Data.fromJson(Map<String, dynamic> json) {
    socialType = json['socialType'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    pushNotification = json['pushNotification'];
    emailNotification = json['emailNotification'];
    filePath = json['filePath'];
    fcmToken = json['fcmToken'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['socialType'] = this.socialType;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['pushNotification'] = this.pushNotification;
    data['emailNotification'] = this.emailNotification;
    data['filePath'] = this.filePath;
    data['fcmToken'] = this.fcmToken;
    data['_id'] = this.sId;
    return data;
  }
}