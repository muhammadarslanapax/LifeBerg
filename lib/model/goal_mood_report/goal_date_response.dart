import 'goal_date_response_data.dart';

class GoalDateResponse {
  bool? success;
  GoalDateResponseData? data;
  String? message;

  GoalDateResponse(
      {this.success, this.data, this.message});

  GoalDateResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new GoalDateResponseData.fromJson(json['data']) : null;
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