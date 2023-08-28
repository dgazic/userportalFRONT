class RegisterResponseModel {
  final String? error;
  bool? success;

  RegisterResponseModel({this.error, this.success});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
        error: json["error"], success: json["success"]);
  }
}

class RegisterRequestModel {
  String? lastName;
  String? firstName;
  String? email;
  String? username;
  String? userRole;
  String? phoneNumber;
  String? hospitalName;

  RegisterRequestModel(
      {this.lastName,
      this.firstName,
      this.email,
      this.username,
      this.userRole,
      this.phoneNumber,
      this.hospitalName});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'lastName': lastName!.trim(),
      'FirstName': firstName!.trim(),
      'email': email!.trim(),
      'username': username!.trim(),
      'userRoleId': userRole,
      'phoneNumber': phoneNumber,
      'hospitalName': hospitalName
    };

    return map;
  }
}
