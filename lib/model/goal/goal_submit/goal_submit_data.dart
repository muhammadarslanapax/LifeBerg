class GoalSubmitData {
  final String goalId;
  String measureType;
  bool isChecked;
  String measureValue;

  GoalSubmitData(
      this.goalId, this.measureType, this.isChecked, this.measureValue);

  // Convert a GoalSubmitData object into a map.
  Map<String, dynamic> toJson() => {
    'goalId': goalId,
    'measureType': measureType,
    'isChecked': isChecked,
    'measureValue': measureValue,
  };

  // Convert a map into a GoalSubmitData object.
  factory GoalSubmitData.fromJson(Map<String, dynamic> json) {
    return GoalSubmitData(
      json['goalId'],
      json['measureType'],
      json['isChecked'],
      json['measureValue'],
    );
  }

}
