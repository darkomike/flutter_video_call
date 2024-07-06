class NotificationModel {
  String? body;
  String? title;
  String? subtitle;

  NotificationModel({this.body, this.title, this.subtitle});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    title = json['title'];
    subtitle = json['subtitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    return data;
  }
}
