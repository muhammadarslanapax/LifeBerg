class MoodHistoryResponseData {
  String? sId;
  String? user;
  String? date;
  String? mood;
  String? comment;

  MoodHistoryResponseData(
      {this.sId, this.user, this.date, this.mood, this.comment});

  MoodHistoryResponseData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    date = json['date'];
    mood = json['mood'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['date'] = this.date;
    data['mood'] = this.mood;
    data['comment'] = this.comment;
    return data;
  }
}
