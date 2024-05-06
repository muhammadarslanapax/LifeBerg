import 'error.dart';

class ErrorResponse {
  bool? success;
  String? message;
  ErrorData? error;

  ErrorResponse({this.success, this.message, this.error});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error =
        json['error'] != null ? new ErrorData.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.error != null) {
      data['error'] = this.error!.toJson();
    }
    return data;
  }
}
