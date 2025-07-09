class LampiranTugasModel {
  int? id;
  int? todoId;
  String? file;

  LampiranTugasModel({this.id, this.todoId, this.file});

  Map<String, dynamic> toJson() => {
        "todo_id": todoId,
        // file tidak dimasukkan ke toJson karena di-handle terpisah
      };

  factory LampiranTugasModel.fromJson(Map<String, dynamic> json) {
    return LampiranTugasModel(
      id: json['id'] is String ? int.tryParse(json['id']) : json['id'],
      todoId: json['todo_id'] is String ? int.tryParse(json['todo_id']) : json['todo_id'],
      file: json['file'] ?? json['file_path'],
    );
  }
}
