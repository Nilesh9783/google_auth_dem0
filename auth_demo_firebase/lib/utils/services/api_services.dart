import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

late Dio _dio;

class APIServices {
  APIServices() {
    updateHeader();
  }

  updateHeader() {
    final BaseOptions dioOptions = BaseOptions()
      ..baseUrl = 'http://www.themealdb.com/api/json/v1/1';
    dioOptions.responseType = ResponseType.plain;
    dioOptions.connectTimeout = const Duration(seconds: 30);
    dioOptions.receiveTimeout = const Duration(seconds: 30);

    dioOptions.headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      "Accept": "application/json"
    };

    _dio = Dio(dioOptions);
  }

  Future<Response<dynamic>> getApiCall(String url) async {
    final Response<dynamic> response = await _dio.get(url);
    throwIfNoSuccess(response);

    return response;
  }

  Future<Response<dynamic>> getAPICallWithQueryParam(
      String url, dynamic data) async {
    final Response<dynamic> response =
        await _dio.get(url, queryParameters: data as Map<String, dynamic>);
    throwIfNoSuccess(response);
    return response;
  }

  void throwIfNoSuccess(Response<dynamic> response) {
    if (response.statusCode! < 200 || response.statusCode! > 299) {
      throw HttpException(response);
    }
  }
}

class HttpException implements Exception {
  HttpException(this.response);
  Response<dynamic> response;
}
