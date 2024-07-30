class GenericResponse {
  bool? success;
  String? message;
  int? data;

  GenericResponse({this.success, this.message});

  GenericResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json["data"] != null && json["data"] is int) {
      data = json['data'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}
