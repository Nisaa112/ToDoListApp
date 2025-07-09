class KategoriUserModel {
  String? name;
  int? userId;
  String? updatedAt;
  String? createdAt;
  int? id;

  KategoriUserModel(
      {this.name, this.userId, this.updatedAt, this.createdAt, this.id});

  KategoriUserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    userId = json['user_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['user_id'] = this.userId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
