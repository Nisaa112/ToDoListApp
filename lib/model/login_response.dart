class LoginResponseModel {
  String? token;
  String? serialNumber;
  int? userId;
  String? tokenType;

  LoginResponseModel({
    this.token,
    this.serialNumber,
    this.userId,
    this.tokenType,
  });
 
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'],
      serialNumber: json['serial_number'],
      tokenType: json['token_type'],
      userId: json['user']?['id'], // ✅ ambil ID dari dalam user
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'serial_number': serialNumber,
      'user_id': userId,
      'token_type': tokenType,
    };
  }
}
