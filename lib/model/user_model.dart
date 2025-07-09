class UserModel {
  String? message;
  List<Data>? data;

  UserModel({this.message, this.data});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      message: json['message'],
      data: json['data'] != null
          ? List<Data>.from(json['data'].map((x) => Data.fromJson(x)))
          : null,
    );
  }
}

class Data {
  final int? id;
  final String? name;
  final String? email;
  final String? photoProfile;
  final String? createdAt;
  final String? updatedAt;

  Data({
    this.id,
    this.name,
    this.email,
    this.photoProfile,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoProfile: json['photo_profile'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo_profile': photoProfile,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Data copyWith({
    int? id,
    String? name,
    String? email,
    String? photoProfile,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoProfile: photoProfile ?? this.photoProfile,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
