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
  bool? isFavorite;
  bool? isArchived;

  // UI-only
  bool isSelected;

  TugasModel({
    this.id,
    this.userId,
    this.categoryId,
    this.title,
    this.difficult,
    this.labelId,
    this.dueDate,
    this.date,
    this.isChecked,
    this.isFavorite,
    this.isArchived,
    this.isSelected = false,
  });

  // ✅ From API
  factory TugasModel.fromJson(Map<String, dynamic> json) {
    return TugasModel(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      title: json['title'],
      difficult: json['difficult'],
      labelId: json['label_id'],
      dueDate: json['due_date'],
      date: json['date'],
      isChecked: json['is_checked'] == 1,
      isFavorite: json['is_favorite'] == 1,
      isArchived: json['is_archived'] == 1,
      isSelected: false,
    );
  }

  // ✅ To API
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'title': title,
      'difficult': difficult,
      'label_id': labelId,
      'due_date': dueDate,
      'date': date,
      'is_checked': (isChecked ?? false) ? 1 : 0,
      'is_favorite': (isFavorite ?? false) ? 1 : 0,
      'is_archived': (isArchived ?? false) ? 1 : 0,
    };
  }

  // ✅ From SQLite
  factory TugasModel.fromMap(Map<String, dynamic> map) {
    return TugasModel(
      id: map['id'],
      userId: map['user_id'],
      categoryId: map['category_id'],
      title: map['title'],
      difficult: map['difficult'],
      labelId: map['label_id'],
      dueDate: map['due_date'],
      date: map['date'],
      isChecked: map['is_checked'] == 1,
      isFavorite: map['is_favorite'] == 1,
      isArchived: map['is_archived'] == 1,
      isSelected: false,
    );
  }

  // ✅ To SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'title': title,
      'difficult': difficult,
      'label_id': labelId,
      'due_date': dueDate,
      'date': date,
      'is_checked': (isChecked ?? false) ? 1 : 0,
      'is_favorite': (isFavorite ?? false) ? 1 : 0,
      'is_archived': (isArchived ?? false) ? 1 : 0,
    };
  }
}
