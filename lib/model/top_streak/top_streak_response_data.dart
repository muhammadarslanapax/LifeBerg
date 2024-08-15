class TopStreakResponseData {
  String? sId;
  String? user;
  int? topScore;

  TopStreakResponseData({this.sId, this.user, this.topScore});

  TopStreakResponseData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    topScore = json['topScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['topScore'] = this.topScore;
    return data;
  }
}