class ErrorDetails {
  String? code;
  String? message;

  ErrorDetails({this.code, this.message});

  ErrorDetails.fromJson(Map<String, dynamic> json) {
    code = json['CODE'];
    message = json['MESSAGE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CODE'] = this.code;
    data['MESSAGE'] = this.message;
    return data;
  }
}