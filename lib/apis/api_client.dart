
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class ApiClient {
  late Dio _dio;
  final int _retryCount = 3; // Number of times to retry a failed request

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        // This will prevent Dio from throwing an exception for status codes like 400
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // final token = await _getToken();
          // if (token != null) {
          //   options.headers["Authorization"] = "Bearer $token";
          // }
          //
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log("Received response: ${response.statusCode}");
          log("Response data: ${response.data}");

          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          _handleError(error);
          return handler.next(error);
        },
      ),
    );
  }





  // Handle errors based on status codes and DioError types
  void _handleError(DioException error) {
    if (error.response != null) {
      switch (error.response!.statusCode) {
        case 400:
          print("Bad request: ${error.response!.data}");
          break;
        case 401:
          print("Unauthorized: ${error.response!.data}");
          break;
        case 403:
          print("Forbidden: ${error.response!.data}");
          break;
        case 404:
          print("Not Found: ${error.response!.data}");
          break;
        case 500:
          print("Internal Server Error: ${error.response!.data}");
          break;
        default:
          print("Received invalid status code: ${error.response!.statusCode}");
      }
    } else {
      if (error.type == DioExceptionType.connectionTimeout) {
        print("Connection Timeout Error: ${error.message}");
      } else if (error.type == DioExceptionType.receiveTimeout) {
        print("Receive Timeout Error: ${error.message}");
      } else if (error.type == DioExceptionType.sendTimeout) {
        print("Send Timeout Error: ${error.message}");
      } else {
        print("Unexpected Error: ${error.message}");
      }
    }
  }

  // Handle token expiration and refresh token
  Future<void> _handleTokenExpired() async {
    // Logic to log out the user or show an expiration message
    print("Token has expired. Please login again.");
  }






  Future<Response?> getWithFullPath(String api, {Map<String, dynamic>? queryParameters}) async {
    try {
      print(api);
      final response = await _dio.get(api,
          queryParameters: queryParameters);
      return response;
    } catch (error) {
      print("Error during GET with full path request: $error");
      return null;
    }
  }

  // POST request
  Future<Response?> post(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } catch (error) {
      print("Error during POST request: $error");
      return null;
    }
  }

  // PUT request
  Future<Response?> put(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response;
    } catch (error) {
      print("Error during PUT request: $error");
      return null;
    }
  }

  // DELETE request
  Future<Response?> delete(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.delete(endpoint, data: data);
      return response;
    } catch (error) {
      print("Error during DELETE request: $error");
      return null;
    }
  }
}
