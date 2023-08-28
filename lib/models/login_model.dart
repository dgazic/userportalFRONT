import 'package:userportal/models/device_model.dart';

class LoginResponseModel{
  String? token;
  final String? error;
  bool? success;


  LoginResponseModel({this.token, this.error, this.success});


  factory LoginResponseModel.fromJson(Map<String,dynamic> json){
    return LoginResponseModel(token: json["token"] != null ? json["token"] : "", error: json["error"], success: json["success"]);
  }
}

class LoginRequestModel{
  String? username;
  String? password;
  DeviceModel? deviceModel = DeviceModel.empty();
  String? sessionUuid;

  LoginRequestModel({
     this.username,
     this.password,
     this.deviceModel,
     this.sessionUuid
  });

  Map<String,dynamic> toJson(){
    Map<String,dynamic> map = {
      'username': username!.trim(),
      'password': password!.trim(),
      'deviceModel': deviceModel!.toJson(),
      'sessionUuid': sessionUuid
    };

    return map;
  }

}