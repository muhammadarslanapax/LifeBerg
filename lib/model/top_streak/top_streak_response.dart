import 'package:life_berg/model/top_streak/top_streak_response_data.dart';

class TopStreakResponse {
  bool? success;
  List<TopStreakResponseData>? data;
  String? message;

  TopStreakResponse(
      {this.success, this.data, this.message,});

  TopStreakResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <TopStreakResponseData>[];
      json['data'].forEach((v) {
        data!.add(new TopStreakResponseData.fromJson(v));
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