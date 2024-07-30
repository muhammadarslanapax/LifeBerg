class ActionPlan {
  String? sId;
  String? user;
  String? name;
  String? category;

  ActionPlan({this.sId, this.user, this.name, this.category});

  ActionPlan.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    name = json['name'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['name'] = this.name;
    data['category'] = this.category;
    return data;
  }
}