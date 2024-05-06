import 'error_detail.dart';

class ErrorData {
  String? code;
  String? message;
  int? status;
  ErrorDetails? details;

  ErrorData({this.code, this.message, this.status, this.details});

  ErrorData.fromJson(Map<String, dynamic> json) {
    code = json['CODE'];
    message = json['MESSAGE'];
    status = json['STATUS'];
    details =
    json['details'] != null ? new ErrorDetails.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CODE'] = this.code;
    data['MESSAGE'] = this.message;
    data['STATUS'] = this.status;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}