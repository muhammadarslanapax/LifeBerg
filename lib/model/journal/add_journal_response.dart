import 'package:life_berg/model/journal/journal_list_response_data.dart';

class AddJournalResponse {
  bool? success;
  JournalListResponseData? data;
  String? message;

  AddJournalResponse(
      {this.success, this.data, this.message, });

  AddJournalResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new JournalListResponseData.fromJson(json['data']) : null;
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