class User {
  String? sId;
  String? socialType;
  String? fullName;
  String? email;
  String? forgotPasswordNonce;
  String? password;
  bool? pushNotification;
  bool? emailNotification;
  String? filePath;
  String? fcmToken;
  String? country;
  String? primaryVocation;
  String? userName;

  User(
      {this.sId,
        this.socialType,
        this.fullName,
        this.email,
        this.forgotPasswordNonce,
        this.password,
        this.pushNotification,
        this.emailNotification,
        this.filePath,
        this.fcmToken,
      this.country,
      this.primaryVocation,
      this.userName});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    socialType = json['socialType'];
    fullName = json['fullName'];
    email = json['email'];
    forgotPasswordNonce = json['forgotPasswordNonce'];
    password = json['password'];
    pushNotification = json['pushNotification'];
    emailNotification = json['emailNotification'];
    filePath = json['filePath'];
    fcmToken = json['fcmToken'];
    country = json['country'];
    primaryVocation = json['primaryVocation'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['socialType'] = this.socialType;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['forgotPasswordNonce'] = this.forgotPasswordNonce;
    data['password'] = this.password;
    data['pushNotification'] = this.pushNotification;
    data['emailNotification'] = this.emailNotification;
    data['filePath'] = this.filePath;
    data['fcmToken'] = this.fcmToken;
    data['country'] = this.country;
    data['primaryVocation'] = this.primaryVocation;
    data['userName'] = this.userName;
    return data;
  }
}