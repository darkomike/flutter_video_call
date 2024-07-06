class VideoModel {
  String? roomId;
  String? callee;

  VideoModel({this.roomId, this.callee});

  VideoModel.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    callee = json['callee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['callee'] = this.callee;
    return data;
  }
}
