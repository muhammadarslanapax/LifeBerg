class Reminders {
  String? dailyStatus;
  String? day;
  String? time;

  Reminders({this.dailyStatus, this.day, this.time});

  Reminders.fromJson(Map<String, dynamic> json) {
    dailyStatus = json['dailyStatus'];
    day = json['day'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dailyStatus'] = this.dailyStatus;
    data['day'] = this.day;
    data['time'] = this.time;
    return data;
  }
}