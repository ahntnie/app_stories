import 'dart:io';

import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10), // 10 giây
    receiveTimeout: const Duration(seconds: 10), // 10 giây
  ));

  ApiService() {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  Future<Response> _handleRedirect(Response response, FormData formData) async {
    if (response.statusCode == 302) {
      print('Vào trường hợp 302');
      final newUrl = response.headers['location']?.first;
      if (newUrl != null) {
        response = await dio.post(
          newUrl,
          data: formData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          ),
        );
      } else {
        throw Exception('No redirection URL found');
      }
    }
    return response;
  }

  Future<Response> getRequest(String url,
      {Map<String, dynamic>? queryParams}) async {
    try {
      Response response = await dio.get(
        url,
        queryParameters: queryParams,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Allow all status codes below 500
          },
        ),
      );

      if (response.statusCode == 302) {
        final newUrl = response.headers['location']?.first;
        if (newUrl != null) {
          response = await dio.get(
            newUrl,
            queryParameters: queryParams,
            options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500; // Allow all status codes below 500
              },
            ),
          );
        } else {
          throw Exception('No redirection URL found');
        }
      }

      return response;
    } catch (e) {
      throw Exception('GET request error: $e');
    }
  }

  Future<Response> postRequest(
    String url,
    FormData data,
  ) async {
    try {
      // Gửi yêu cầu POST ban đầu
      Response response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'ngrok-skip-browser-warning': 'true'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Cho phép tất cả các mã trạng thái dưới 500
          },
        ),
      );
      response = await _handleRedirect(response, data);
      return response;
    } catch (e) {
      throw Exception('POST request error: $e');
    }
  }

  Future<Response> patchRequest(String url, Map<String, dynamic>? data) async {
    try {
      Response response;
      if (data != null) {
        final formData = FormData.fromMap(data);
        response = await dio.patch(
          url,
          data: formData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500; // Allow all status codes below 500
            },
          ),
        );
        response = await _handleRedirect(response, formData);
      } else {
        response = await dio.patch(
          url,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500; // Allow all status codes below 500
            },
          ),
        );
      }

      return response;
    } catch (e) {
      throw Exception('PATCH request error: $e');
    }
  }

  Future<Response> deleteRequest(String url,
      {Map<String, dynamic>? data}) async {
    try {
      Response response = await dio.delete(
        url,
        data: data,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Allow all status codes below 500
          },
        ),
      );

      if (response.statusCode == 302) {
        final newUrl = response.headers['location']?.first;
        if (newUrl != null) {
          response = await dio.delete(
            newUrl,
            data: data,
            options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500; // Allow all status codes below 500
              },
            ),
          );
        } else {
          throw Exception('No redirection URL found');
        }
      }

      return response;
    } catch (e) {
      throw Exception('DELETE request error: $e');
    }
  }
}
