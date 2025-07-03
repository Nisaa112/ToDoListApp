class TugasModel {
  int? id;
  int? userId;
  int? categoryId;
  String? title;
  String? difficult;
  int? labelId;
  String? dueDate;
  String? date;
  bool? isChecked;

  TugasModel(
      {this.id, 
      this.userId,
      this.categoryId,
      this.title,
      this.difficult,
      this.labelId,
      this.dueDate,
      this.date,
      this.isChecked});

  TugasModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    title = json['title'];
    difficult = json['difficult'];
    labelId = json['label_id'];
    dueDate = json['due_date'];
    date = json['date'];
    isChecked = json['is_checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (id != null) data['id'] = id;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['difficult'] = this.difficult;
    data['label_id'] = this.labelId;
    data['due_date'] = this.dueDate;
    data['date'] = this.date;
    data['is_checked'] = this.isChecked;
    return data;
  }
}
