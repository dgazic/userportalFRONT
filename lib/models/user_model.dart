class UserResponseModel {
  int? id;
  String? email;
  String? username;
  dynamic passwordHash;
  dynamic passwordSalt;
  String? lastName;
  String? firstName;
  int? userRoleId;
  String? userRoleName;
  bool? success;
  int? activated;
  String? phoneNumber;
  String? hospital;

  UserResponseModel(
      {this.id,
      this.email,
      this.username,
      this.lastName,
      this.userRoleId,
      this.userRoleName,
      this.firstName,
      this.success,
      this.activated,
      this.phoneNumber,
      this.hospital});

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
        id: json["id"],
        email: json["email"],
        username: json["username"],
        lastName: json["lastName"],
        firstName: json["firstName"],
        userRoleId: json["userRoleId"],
        userRoleName: json["userRoleName"],
        success: json["success"],
        activated: json["activated"],
        phoneNumber: json["phoneNumber"],
        hospital: json["hospital"]);
  }
}

class UserRequestModel {
  int? id;
  String? email;
  String? username;
  String? lastName;
  String? firstName;
  int? userRoleId;
  String? phoneNumber;
  int? activated;

  UserRequestModel(
      {this.id,
      this.email,
      this.username,
      this.lastName,
      this.firstName,
      this.userRoleId,
      this.phoneNumber,
      this.activated});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'id': id!,
      'lastName': lastName,
      'firstName': firstName,
      'email': email,
      'username': username,
      'userRoleId': userRoleId,
      'phoneNumber': phoneNumber,
      'activated': activated
    };

    return map;
  }
}
