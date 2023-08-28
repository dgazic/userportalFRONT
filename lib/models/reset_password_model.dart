class ResetPasswordResponseModel{
  final String? error;
  bool? success;


  ResetPasswordResponseModel({this.error, this.success});


  factory ResetPasswordResponseModel.fromJson(Map<String,dynamic> json){
    return ResetPasswordResponseModel(error: json["error"], success: json["success"]);
  }
}

class ResetPasswordRequestModel{
  String? email;


  ResetPasswordRequestModel({
     this.email,
  });

  Map<String,dynamic> toJson(){
    Map<String,dynamic> map = {
      'email': email!.trim(),
    };

    return map;
  }

}