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

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    serialNumber = json['serial_number'];
    userId = json['user_id'];
    tokenType = json['token_type'];
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
