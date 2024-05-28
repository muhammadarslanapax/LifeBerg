import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:life_berg/model/goal/reminders.dart';

import 'category.dart';
import 'goal_measure.dart';

class Goal {
  String? sId;
  String? user;
  String? icon;
  String? name;
  Category? category;
  String? achieveXDays;
  String? achieveType;
  String? goalImportance;
  String? description;
  String? status;
  GoalMeasure? goalMeasure;
  List<Reminders>? reminders;
  String? color;
  RxBool isChecked = false.obs;
  RxDouble sliderValue = 0.0.obs;

  Goal(
      {this.sId,
      this.user,
      this.icon,
      this.name,
      this.category,
      this.achieveXDays,
      this.achieveType,
      this.goalImportance,
      this.description,
      this.status,
      this.goalMeasure,
      this.reminders,
      this.color});

  Goal.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    icon = json['icon'];
    name = json['name'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    achieveXDays = json['achieveXDays'];
    achieveType = json['achieveType'];
    goalImportance = json['goalImportance'];
    description = json['description'];
    status = json['status'];
    goalMeasure = json['goalMeasure'] != null
        ? new GoalMeasure.fromJson(json['goalMeasure'])
        : null;
    if (json['reminders'] != null) {
      reminders = <Reminders>[];
      json['reminders'].forEach((v) {
        reminders!.add(new Reminders.fromJson(v));
      });
    }
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['icon'] = this.icon;
    data['name'] = this.name;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['achieveXDays'] = this.achieveXDays;
    data['achieveType'] = this.achieveType;
    data['goalImportance'] = this.goalImportance;
    data['description'] = this.description;
    data['status'] = this.status;
    if (this.goalMeasure != null) {
      data['goalMeasure'] = this.goalMeasure!.toJson();
    }
    if (this.reminders != null) {
      data['reminders'] = this.reminders!.map((v) => v.toJson()).toList();
    }
    data['color'] = this.color;
    return data;
  }
}
