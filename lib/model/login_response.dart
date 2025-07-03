class LoginResponseModel {
  final String token;
  final String serialNumber;
  final String tokenType;

  LoginResponseModel({
    required this.token,
    required this.serialNumber,
    required this.tokenType,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'],
      serialNumber: json['serial_number'],
      tokenType: json['token_type'],
    );
  }
}
