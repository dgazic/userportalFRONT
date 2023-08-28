import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:userportal/models/account_activation_model.dart';
import 'package:userportal/models/login_model.dart';
import 'package:userportal/models/register_model.dart';
import 'package:userportal/models/reset_password_model.dart';
import 'package:userportal/models/user_model.dart';
import 'package:userportal/constants.dart';
import 'package:userportal/resources/EnumApiRequests.dart';
import 'package:userportal/services/network_handler/API_Client.dart';
import 'package:userportal/services/network_handler/app_preferences.dart';
import 'package:userportal/services/network_handler/jwt_decoder.dart';

final urlApi = url;
String? token;
APIClient _apiClient = new APIClient();

class UserProvider with ChangeNotifier {
  Future<List<UserResponseModel>> fetchUsers() async {
    try {
      final String userHospital = jwtDecoder().getToken()['UserHospital'];

      String url = urlApi + '/user/GetUsers/';
      Map<String, dynamic>? qParam = {"userHospital": userHospital};
      var response = await _apiClient.request(API_REQUEST.GET, url, null,
          queryParameters: qParam);

      final responseData = response.cast<Map<String, dynamic>>();

      return responseData
          .map<UserResponseModel>((json) => UserResponseModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Fail to retrieve users of hospital');
    }
  }

  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    try {
      String url = urlApi + '/auth/login/';
      var response =
          await _apiClient.request(API_REQUEST.POST, url, requestModel);

      var responseData = LoginResponseModel.fromJson(response);
      token = responseData.token;
      AppPreferences.storeToken(token!);
      return responseData;
    } catch (e) {
      return LoginResponseModel();
    }
  }

  Future<RegisterResponseModel> register(
      RegisterRequestModel requestModel) async {
    try {
      String url = urlApi + '/auth/register/';
      var response =
          await _apiClient.request(API_REQUEST.POST, url, requestModel);

      var responseData = RegisterResponseModel.fromJson(response);
      return responseData;
    } catch (e) {
      return RegisterResponseModel();
    }
  }

  Future<ActivationAccountResponseModel> activateAccount(
      ActivationAccountRequestModel requestModel) async {
    try {
      String url = urlApi + '/auth/activateAccount/';
      var response =
          await _apiClient.request(API_REQUEST.PUT, url, requestModel);

      var responseData = ActivationAccountResponseModel.fromJson(response);
      return responseData;
    } catch (e) {
      return ActivationAccountResponseModel();
    }
  }

  Future<ResetPasswordResponseModel> resetPassword(
      ResetPasswordRequestModel requestModel) async {
    try {
      String url = urlApi + '/auth/resetPassword/';
      var response =
          await _apiClient.request(API_REQUEST.POST, url, requestModel);
      var responseData = ResetPasswordResponseModel.fromJson(response);
      return responseData;
    } catch (e) {
      return ResetPasswordResponseModel();
    }
  }

  Future<UserResponseModel> deleteUser(UserRequestModel requestModel) async {
    try {
      String url = urlApi + '/user/deleteUser/';
      var response =
          await _apiClient.request(API_REQUEST.DELETE, url, requestModel);
      var responseData = UserResponseModel.fromJson(response);
      return responseData;
    } catch (e) {
      return UserResponseModel();
    }
  }

  Future<UserResponseModel> activateDeactivateUser(
      UserRequestModel requestModel) async {
    try {
      String url = urlApi + '/user/activateDeactivateUser/';
      var response =
          await _apiClient.request(API_REQUEST.PUT, url, requestModel);
      var responseData = UserResponseModel.fromJson(response);
      return responseData;
    } catch (e) {
      return UserResponseModel();
    }
  }

  Future<UserResponseModel> updateUser(UserRequestModel requestModel) async {
    try {
      String url = urlApi + '/user/updateUser/';
      var response =
          await _apiClient.request(API_REQUEST.PUT, url, requestModel);
      var responseData = UserResponseModel.fromJson(response);
      return responseData;
    } catch (e) {
      return UserResponseModel();
    }
  }

  Future<List<String>> GetHospitals() async {
    try {
      String url = urlApi + '/User/GetHospitals/';
      var response = await _apiClient.request(API_REQUEST.GET, url, null);
      List<String> items = [];
      var jsonData = response as List;
      for (var element in jsonData) {
        items.add(element["shortName"]);
      }
      return items;
    } catch (e) {
      throw Exception('Failed to get hospitals');
    }
  }

  Future<ActivationAccountResponseModel> IsActivationTokenValid(
      String? activationToken) async {
    try {
      String url = urlApi + '/Auth/IsActivationTokenValid/';
      Map<String, dynamic>? qParam = {"activationToken": activationToken};
      var response = await _apiClient.request(API_REQUEST.GET, url, null,
          queryParameters: qParam);

      var responseData = ActivationAccountResponseModel.fromJson(response);
      return responseData;
    } catch (e) {
      return ActivationAccountResponseModel();
    }
  }
}
