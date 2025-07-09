class DifficultyModel {
  String? name;
  String? updatedAt;
  String? createdAt;
  int? id;

  DifficultyModel({this.name, this.updatedAt, this.createdAt, this.id});

  DifficultyModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
