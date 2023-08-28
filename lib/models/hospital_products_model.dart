class HospitalProductsModelResponse{
  String? ProductName;


  HospitalProductsModelResponse({this.ProductName});


  factory HospitalProductsModelResponse.fromJson(Map<String,dynamic> json){
    return HospitalProductsModelResponse(ProductName: json["ProductName"]);
  }
}

class HospitalProductsModelRequest{
  String? hospitalName;
  HospitalProductsModelRequest({
     this.hospitalName
  });

  Map<String,dynamic> toJson(){
    Map<String,dynamic> map = {
      'hospitalName': hospitalName!.trim(),
    };

    return map;
  }

}