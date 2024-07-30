import 'action_plan.dart';

class ActionPlanListResponse {
  bool? success;
  List<ActionPlan>? data;
  String? message;

  ActionPlanListResponse(
      {this.success, this.data, this.message,});

  ActionPlanListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ActionPlan>[];
      json['data'].forEach((v) {
        data!.add(new ActionPlan.fromJson(v));
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