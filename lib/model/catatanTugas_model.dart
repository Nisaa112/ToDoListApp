class CatatanTugasModel {
  String? message;
  Data? data;

  CatatanTugasModel({this.message, this.data});

  CatatanTugasModel.fromJson(Map<String, dynamic> json) {
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
  int? todoId;
  String? note;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data({this.todoId, this.note, this.updatedAt, this.createdAt, this.id});

  Data.fromJson(Map<String, dynamic> json) {
    todoId = json['todo_id'];
    note = json['note'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['todo_id'] = this.todoId;
    data['note'] = this.note;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      id: map['id'],
      todoId: map['todo_id'],
      note: map['note'],
      updatedAt: map['updated_at'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todo_id': todoId,
      'note': note,
      'updated_at': updatedAt,
      'created_at': createdAt,
    };
  }

}
