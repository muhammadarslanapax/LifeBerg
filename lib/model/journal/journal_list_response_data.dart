class JournalListResponseData {
  String? sId;
  String? description;
  String? category;
  String? user;
  String? color;
  String? date;

  JournalListResponseData(
      {this.sId,
        this.description,
        this.category,
        this.user,
        this.color,
        this.date});

  JournalListResponseData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    description = json['description'];
    category = json['category'];
    user = json['user'];
    color = json['color'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['description'] = this.description;
    data['category'] = this.category;
    data['user'] = this.user;
    data['color'] = this.color;
    data['date'] = this.date;
    return data;
  }
}