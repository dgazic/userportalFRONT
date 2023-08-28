class ActivationAccountResponseModel {
  final String? error;
  bool? success;
  bool? isTokenValid;

  ActivationAccountResponseModel({this.error, this.success, this.isTokenValid});

  factory ActivationAccountResponseModel.fromJson(Map<String, dynamic> json) {
    return ActivationAccountResponseModel(
        error: json["error"],
        success: json["success"],
        isTokenValid: json["isTokenValid"]);
  }
}

class ActivationAccountRequestModel {
  String? password;
  String? activationToken;
  ActivationAccountRequestModel({this.password, this.activationToken});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'password': password!.trim(),
      'activationToken': activationToken!.trim()
    };

    return map;
  }
}
