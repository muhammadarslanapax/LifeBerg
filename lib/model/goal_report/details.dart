import '../goal/goal.dart';

class Details {
  String? type;
  String? value;
  String? comment;
  Goal? goal;

  Details({this.type, this.value, this.comment, this.goal});

  Details.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
    comment = json['comment'];
    goal = json['goal'] != null ? new Goal.fromJson(json['goal']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    data['comment'] = this.comment;
    if (this.goal != null) {
      data['goal'] = this.goal!.toJson();
    }
    return data;
  }
}
