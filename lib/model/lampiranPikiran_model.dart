class LampiranPikiranModel {
  String? message;
  Data? data;

  LampiranPikiranModel({this.message, this.data});

  LampiranPikiranModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userId;
  String? catatanPikiranId;
  String? filePath;
  String? fileType;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.userId,
      this.catatanPikiranId,
      this.filePath,
      this.fileType,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    catatanPikiranId = json['catatan_pikiran_id'];
    filePath = json['file_path'];
    fileType = json['file_type'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['catatan_pikiran_id'] = this.catatanPikiranId;
    data['file_path'] = this.filePath;
    data['file_type'] = this.fileType;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
