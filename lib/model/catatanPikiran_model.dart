class CatatanPikiranModel {
  int? userId;
  String? judul;
  String? isi;
  String? updatedAt;
  String? createdAt;
  int? id;

  CatatanPikiranModel(
      {this.userId,
      this.judul,
      this.isi,
      this.updatedAt,
      this.createdAt,
      this.id});

  CatatanPikiranModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    judul = json['judul'];
    isi = json['isi'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['judul'] = this.judul;
    data['isi'] = this.isi;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
