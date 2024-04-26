import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logger/web.dart';
import 'package:task_manager_app/constants/api_constant.dart';
import 'package:task_manager_app/services/network_service/api_response.dart';

class ApiClient {
  static const int _timeOut = 120;
  final _dio = Dio();
  Future<ApiResponse> get(
    String path, {
    String? baseUrl,
    Uri? uri,
    Map<String, String>? headers,
    Map<String, dynamic>? parameters,
    int? timeOut,
  }) async {
    final url =
        uri ?? Uri.http(baseUrl ?? ApiConstants.baseUrl, path, parameters);

    return await requestServer(() async {
      final response = await _dio
          .getUri(
            url,
            options: Options(headers: headers),
          )
          .timeout(Duration(seconds: timeOut ?? _timeOut));

      return _handleStatusCode(response);
    });
  }

  Future<ApiResponse> post(
    String path, {
    String? baseUrl,
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? parameters,
  }) async {
    final url = Uri.https(baseUrl ?? ApiConstants.baseUrl, path, parameters);
Logger().w(body);
    return await requestServer(() async {
      final response = await _dio
          .postUri(url, data: body, options: Options(headers: headers))
          .timeout(const Duration(seconds: _timeOut));

      return _handleStatusCode(response);
    });
  }

  Future<ApiResponse> requestServer(Future Function() computation) async {
    try {
      return await computation();
    } on SocketException {
      throw "No Internet Connection";
    } on FormatException {
      throw "Format Error";
    } on HttpException {
      throw "Something Went Wrong";
    } on TimeoutException {
      throw "Time Out Error";
    } on DioException catch (error) {
      throw _checkDioErrorType(error);
      // throw error;
    }
  }

  _checkDioErrorType(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        throw "Connection Time out";
      case DioExceptionType.sendTimeout:
        throw "Send Timeout";
      case DioExceptionType.receiveTimeout:
        throw "Receive timeout";
      case DioExceptionType.badResponse:
        if (error.response != null &&
            error.response?.statusCode != null &&
            error.response?.statusMessage != null) {
          _handleStatusCode(error.response!);
        } else {
          throw "Some thing went wrong";
        }
      case DioExceptionType.cancel:
        throw "The request is canceled";
      default:
        throw "Something went wrong";
    }
  }
}

ApiResponse _handleStatusCode(Response response) {
  switch (response.statusCode) {
    case 200:
    case 201:
    case 202:
      final headers = response.headers;
      dynamic body;
      try {
        body = jsonDecode(response.data);
      } catch (error) {
        body = response.data;
      }
      return ApiResponse(
        body: body,
        headers: headers,
      );
    case 204:
      return ApiResponse(
        body: response.data,
        headers: response.headers,
      );
    case 400:
      throw response.data['message'];
    case 401:
    case 403:
      throw "Unauthorized Error";
    case 404:
      throw "Not Found";
    case 500:
    default:
      throw "internal Server Error";
  }
}
