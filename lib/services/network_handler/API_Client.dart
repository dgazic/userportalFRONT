import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userportal/resources/routes_manager.dart';
import 'app_preferences.dart';

class APIClient with ChangeNotifier {
  final Dio _dio = Dio();

  Future<T> request<T>(
    String method,
    String url,
    dynamic data, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final token = await AppPreferences.getToken('token');
      final response = await _dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            'Authorization': 'Bearer $token'
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        Get.offNamed(Routes.sessionExpiredScreen);
      }
      throw Exception('Request failed: ${e.toString()}');
    } catch (e) {
      throw Exception('Request failed: ${e.toString()}');
    }
  }
}
