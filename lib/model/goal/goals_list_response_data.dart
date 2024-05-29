import 'goal.dart';

class GoalsListResponseData {
  List<Goal>? wellBeing;
  List<Goal>? vocational;
  List<Goal>? personalDevelopment;

  GoalsListResponseData(
      {this.wellBeing, this.vocational, this.personalDevelopment});

  GoalsListResponseData.fromJson(Map<String, dynamic> json) {
    if (json['Wellbeing'] != null) {
      wellBeing = <Goal>[];
      json['Wellbeing'].forEach((v) {
        wellBeing!.add(new Goal.fromJson(v));
      });
    }
    if (json['Vocational'] != null) {
      vocational = <Goal>[];
      json['Vocational'].forEach((v) {
        vocational!.add(new Goal.fromJson(v));
      });
    }
    if (json['Personal Development'] != null) {
      personalDevelopment = <Goal>[];
      json['Personal Development'].forEach((v) {
        personalDevelopment!.add(new Goal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.wellBeing != null) {
      data['Wellbeing'] = this.wellBeing!.map((v) => v.toJson()).toList();
    }
    if (this.vocational != null) {
      data['Vocational'] = this.vocational!.map((v) => v.toJson()).toList();
    }
    if (this.personalDevelopment != null) {
      data['Personal Development'] =
          this.personalDevelopment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
