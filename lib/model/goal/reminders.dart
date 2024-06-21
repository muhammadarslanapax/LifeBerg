class Reminders {
  List<String>? day;
  String? time;

  Reminders({this.day, this.time});

  Reminders.fromJson(Map<String, dynamic> json) {
    if (json['day'] != null) {
      day = List<String>.from(json['day']);
    }
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.day != null) {
      data['day'] = this.day;
    }
    data['time'] = this.time;
    return data;
  }
}