import 'package:billingsphere/utils/constant.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const Map<String, dynamic> DEFAULT_HEADERS = {
  'Content-Type': 'application/json'
};

class API {
  final Dio _dio = Dio();
  API() {
    _dio.options.baseUrl = Constants.baseUrl;
    _dio.options.headers = DEFAULT_HEADERS;
    //interceptors
    _dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true));
  }

  Dio get sendRequest => _dio;
}

class APIResponse {
  bool success;
  dynamic data;
  String? message;
  String? token;
  APIResponse({
    required this.success,
    this.data,
    this.message,
    this.token,
  });
  factory APIResponse.fromResponse(Response response) {
    final data = response.data as Map<String, dynamic>;
    return APIResponse(
      success: data["success"],
      data: data["data"],
      message: data["message"] ?? "Unexpected Error",
      token: data["token"],
    );
  }
}
