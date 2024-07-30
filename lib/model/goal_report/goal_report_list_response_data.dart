import 'details.dart';
import 'highlight.dart';

class GoalReportListResponseData {
  HighLight? highLight;
  String? sId;
  String? user;
  String? date;
  List<Details>? details;

  GoalReportListResponseData(
      {this.highLight, this.sId, this.user, this.date, this.details});

  GoalReportListResponseData.fromJson(Map<String, dynamic> json) {
    highLight = json['highLight'] != null
        ? new HighLight.fromJson(json['highLight'])
        : null;
    sId = json['_id'];
    user = json['user'];
    date = json['date'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.highLight != null) {
      data['highLight'] = this.highLight!.toJson();
    }
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['date'] = this.date;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
