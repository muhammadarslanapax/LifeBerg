class User {
  String? sId;
  String? socialType;
  String? fullName;
  String? email;
  String? dob;
  String? forgotPasswordNonce;
  String? password;
  bool? pushNotification;
  bool? emailNotification;
  String? filePath;
  String? fcmToken;
  String? country;
  String? primaryVocation;
  String? userName;
  String? lifeBergName;
  String? profilePicture;
  int? currentStreak;

  User(
      {this.sId,
      this.socialType,
      this.fullName,
      this.email,
      this.dob,
      this.forgotPasswordNonce,
      this.password,
      this.pushNotification,
      this.emailNotification,
      this.filePath,
      this.fcmToken,
      this.country,
      this.primaryVocation,
      this.userName,
      this.lifeBergName,
      this.profilePicture,
      this.currentStreak});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    socialType = json['socialType'];
    fullName = json['fullName'];
    email = json['email'];
    dob = json['dob'];
    forgotPasswordNonce = json['forgotPasswordNonce'];
    password = json['password'];
    pushNotification = json['pushNotification'];
    emailNotification = json['emailNotification'];
    filePath = json['filePath'];
    fcmToken = json['fcmToken'];
    country = json['country'];
    primaryVocation = json['primaryVocation'];
    userName = json['userName'];
    lifeBergName = json['lifeBergName'];
    profilePicture = json['profilePicture'];
    currentStreak = json['currentStreak'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['socialType'] = this.socialType;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['forgotPasswordNonce'] = this.forgotPasswordNonce;
    data['password'] = this.password;
    data['pushNotification'] = this.pushNotification;
    data['emailNotification'] = this.emailNotification;
    data['filePath'] = this.filePath;
    data['fcmToken'] = this.fcmToken;
    data['country'] = this.country;
    data['primaryVocation'] = this.primaryVocation;
    data['userName'] = this.userName;
    data['lifeBergName'] = this.lifeBergName;
    data['profilePicture'] = this.profilePicture;
    data['currentStreak'] = this.currentStreak;
    return data;
  }
}
