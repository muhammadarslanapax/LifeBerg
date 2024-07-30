import 'goal_report_list_response_data.dart';

class GoalReportListResponse {
  bool? success;
  List<GoalReportListResponseData>? data;
  String? message;

  GoalReportListResponse(
      {this.success, this.data, this.message, });

  GoalReportListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <GoalReportListResponseData>[];
      json['data'].forEach((v) {
        data!.add(new GoalReportListResponseData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}
