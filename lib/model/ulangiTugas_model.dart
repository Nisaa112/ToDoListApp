class UlangiTugasModel {
  String? message;
  Data? data;

  UlangiTugasModel({this.message, this.data});

  UlangiTugasModel.fromJson(Map<String, dynamic> json) {
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
  String? repeatType;
  int? intervalDays;
  String? startDate;
  String? endDate;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.todoId,
      this.repeatType,
      this.intervalDays,
      this.startDate,
      this.endDate,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    todoId = json['todo_id'];
    repeatType = json['repeat_type'];
    intervalDays = json['interval_days'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['todo_id'] = this.todoId;
    data['repeat_type'] = this.repeatType;
    data['interval_days'] = this.intervalDays;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}