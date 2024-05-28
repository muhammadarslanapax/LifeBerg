import 'goals_list_response_data.dart';

class GoalsListResponse {
  bool? success;
  GoalsListResponseData? data;
  String? message;

  GoalsListResponse(
      {this.success, this.data, this.message, });

  GoalsListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new GoalsListResponseData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}