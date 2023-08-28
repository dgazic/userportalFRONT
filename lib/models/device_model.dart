class DeviceModel {
  String? applicationType;
  String? devicePlatform;
  String? deviceVersion;
  String? deviceBrand;
  String? deviceModel;
  String? browser;
  String? browserVersion;

  DeviceModel(
    this.applicationType,
    this.devicePlatform,
    this.deviceVersion,
    this.deviceBrand,
    this.deviceModel,
    this.browser,
    this.browserVersion,
  );

    Map<String,dynamic> toJson(){
    Map<String,dynamic> map = {
      'applicationType': applicationType,
      'devicePlatform': devicePlatform,
      'deviceVersion': deviceVersion,
      'deviceBrand': deviceBrand,
      'deviceModel': deviceModel,
      'browser': browser,
      'browserVersion': browserVersion,
    };

    return map;
  }

  DeviceModel.empty();
}
