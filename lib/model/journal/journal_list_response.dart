import 'journal_list_response_data.dart';

class JournalListResponse {
  bool? success;
  List<JournalListResponseData>? data;
  String? message;

  JournalListResponse(
      {this.success, this.data, this.message, });

  JournalListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <JournalListResponseData>[];
      json['data'].forEach((v) {
        data!.add(new JournalListResponseData.fromJson(v));
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