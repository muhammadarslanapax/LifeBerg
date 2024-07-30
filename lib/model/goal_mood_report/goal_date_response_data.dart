import 'check_reports.dart';

class GoalDateResponseData {
  // Null? mood;
  CheckReports? checkReports;

  GoalDateResponseData({/*this.mood,*/ this.checkReports});

  GoalDateResponseData.fromJson(Map<String, dynamic> json) {
    // mood = json['mood'];
    checkReports = json['checkReports'] != null
        ? new CheckReports.fromJson(json['checkReports'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['mood'] = this.mood;
    if (this.checkReports != null) {
      data['checkReports'] = this.checkReports!.toJson();
    }
    return data;
  }
}
