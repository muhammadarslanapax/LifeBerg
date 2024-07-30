import 'mood_history_response_data.dart';

class MoodHistoryResponse {
  bool? success;
  List<MoodHistoryResponseData>? data;
  String? message;

  MoodHistoryResponse(
      {this.success, this.data, this.message, });

  MoodHistoryResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <MoodHistoryResponseData>[];
      json['data'].forEach((v) {
        data!.add(new MoodHistoryResponseData.fromJson(v));
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
