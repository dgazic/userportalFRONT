import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:userportal/constants.dart';
import 'package:userportal/models/ticket_attachment_model.dart';
import 'package:userportal/models/ticket_model.dart';
import 'package:userportal/resources/EnumApiRequests.dart';
import 'package:userportal/services/network_handler/API_Client.dart';
import 'package:userportal/services/network_handler/jwt_decoder.dart';

final urlApi = url;
String? token;

class TicketProvider with ChangeNotifier {
  APIClient _apiClient = new APIClient();

  Future<TicketRegistrationResponseModel> ticketRegistration(
      TicketRegistrationRequestModel requestModel) async {
    try {
      final url = urlApi + '/Ticket/TicketRegistration';
      var response =
          await _apiClient.request(API_REQUEST.POST, url, requestModel);

      var responseData = TicketRegistrationResponseModel.fromJson(response);
      return responseData;
    } catch (e) {
      return TicketRegistrationResponseModel();
    }
  }

  Future<TicketRegistrationResponseModel> CloseTicket(int id) async {
    try {
      final url = urlApi + '/Ticket/CloseTicket/';
      Map<String, dynamic>? qParam = {"id": id};
      var response = await _apiClient.request(API_REQUEST.POST, url, null,
          queryParameters: qParam);
      var responseData = TicketRegistrationResponseModel.fromJson(response);
      return responseData;
    } catch (e) {
      return TicketRegistrationResponseModel();
    }
  }

  Future<TicketRegistrationResponseModel> ChangeTicketPriority(
      TicketChangePriorityRequestModel requestModel) async {
    try {
      final url = urlApi + '/Ticket/ChangeTicketPriority';
      var response =
          await _apiClient.request(API_REQUEST.POST, url, requestModel);
      var responseData = TicketRegistrationResponseModel.fromJson(response);
      return responseData;
    } catch (e) {
      return TicketRegistrationResponseModel();
    }
  }

  Future<TicketsGetAllResponseModel> GetTicket(int id) async {
    try {
      final url = urlApi + '/ticket/TicketById/';
      Map<String, dynamic>? qParam = {"id": id};
      var response = await _apiClient.request(API_REQUEST.GET, url, null,
          queryParameters: qParam);
      var responseData = TicketsGetAllResponseModel.fromJson(response);
      return responseData;
    } catch (e) {
      return TicketsGetAllResponseModel();
    }
  }

  Future<List<TicketsGetAllResponseModel>> fetchAllTickets(
      TicketsGetFilterDateRequestModel requestModel) async {
    try {
      String url = urlApi + '/ticket/GetTickets/';

      Map<String, dynamic>? qParam = {
        "enrollmentTimeDateFrom": requestModel.enrollmentTimeDateFrom,
        "enrollmentTimeDateTo": requestModel.enrollmentTimeDateTo
      };

      var response = await _apiClient.request(API_REQUEST.GET, url, null,
          queryParameters: qParam);

      final responseData = response.cast<Map<String, dynamic>>();
      return responseData
          .map<TicketsGetAllResponseModel>(
              (json) => TicketsGetAllResponseModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all tickets');
    }
  }

  Future<List<TicketAttachmentModel>> GetTicketAttachment(int id) async {
    try {
      final url = urlApi + '/ticket/GetTicketAttachment/';
      Map<String, dynamic>? qParam = {"id": id};
      var response = await _apiClient.request(API_REQUEST.GET, url, null,
          queryParameters: qParam);
      final responseData = response.cast<Map<String, dynamic>>();
      return responseData
          .map<TicketAttachmentModel>(
              (json) => TicketAttachmentModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get ticket attachments');
    }
  }

  Future<List<String>> GetHospitalProducts() async {
    try {
      final String userHospital = jwtDecoder().getToken()['UserHospital'];
      final url = urlApi + '/ticket/GetHospitalProducts/';

      Map<String, dynamic>? qParam = {"userHospital": userHospital};
      var response = await _apiClient.request(API_REQUEST.GET, url, null,
          queryParameters: qParam);
      List<String> items = [];
      var responseData = response as List;
      for (var element in responseData) {
        items.add(element["productName"]);
      }
      return items;
    } catch (e) {
      throw Exception('Failed to get hospital products');
    }
  }

  Future<List<String>> GetHospitals() async {
    try {
      final url = urlApi + '/ticket/GetHospitals';
      var response = await _apiClient.request(API_REQUEST.GET, url, null);
      List<String> items = [];
      var responseData = response as List;
      for (var element in responseData) {
        items.add(element["shortName"]);
      }
      return items;
    } catch (e) {
      throw Exception('Failed to get hospitals');
    }
  }

  Future<List<String>> GetHospitalUsers(String? hospitalName) async {
    try {
      String url = urlApi + '/ticket/GetHospitalUsers/';
      Map<String, dynamic>? qParam = {"hospitalName": hospitalName};
      var response = await _apiClient.request(API_REQUEST.GET, url, null,
          queryParameters: qParam);

      List<String> items = [];
      var responseData = response as List;
      for (var element in responseData) {
        items.add(element["lastNameFirstName"]);
      }
      return items;
    } catch (e) {
      throw Exception('Failed to get hospital users');
    }
  }

  Future<List<String>> GetProductDomains(String productName) async {
    try {
      if (productName.isEmpty) return <String>[];
      String url = urlApi + '/ticket/GetProductDomains/';
      Map<String, dynamic>? qParam = {"productName": productName};
      var response = await _apiClient.request(API_REQUEST.GET, url, null,
          queryParameters: qParam);
      List<String> items = [];
      var responseData = response as List;
      for (var element in responseData) {
        items.add(element["productDomain"]);
      }
      return items;
    } catch (e) {
      throw Exception('Failed to get product domains');
    }
  }
}
