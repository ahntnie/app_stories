import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 60), // 10 giây
    receiveTimeout: const Duration(seconds: 60), // 10 giây
  ));

  ApiService() {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  Future<Response> _handleRedirect(Response response, FormData formData) async {
    if (response.statusCode == 302) {
      final newUrl = response.headers['location']?.first;
      if (newUrl != null) {
        response = await dio.post(
          newUrl,
          data: formData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
              'ngrok-skip-browser-warning': 'true'
            },
          ),
        );
      } else {
        throw Exception('No redirection URL found');
      }
    }
    return response;
  }

  Future<Response> _handleRedirectPath(
      Response response, String formData) async {
    if (response.statusCode == 302) {
      final newUrl = response.headers['location']?.first;
      if (newUrl != null) {
        response = await dio.patch(
          newUrl,
          data: formData,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
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

  Future<Response> postFavourite(String url, Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'ngrok-skip-browser-warning': 'true'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Allow all status codes below 500
          },
        ),
      );
      final formDataNew = FormData.fromMap(data);

      response = await _handleRedirect(response, formDataNew);
      print(response.data);
      return response;
    } catch (e) {
      throw Exception('POST request error: $e');
    }
  }

  Future<Response> postNotifications(
      String url, Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'ngrok-skip-browser-warning': 'true'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Allow all status codes below 500
          },
        ),
      );
      final formDataNew = FormData.fromMap(data);

      response = await _handleRedirect(response, formDataNew);
      print(response.data);
      return response;
    } catch (e) {
      throw Exception('POST request error: $e');
    }
  }

  Future<Response> postRequestUser(
      String url, Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'ngrok-skip-browser-warning': 'true'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Allow all status codes below 500
          },
        ),
      );
      final formDataNew = FormData.fromMap(data);

      response = await _handleRedirect(response, formDataNew);
      return response;
    } catch (e) {
      throw Exception('POST request error: $e');
    }
  }

  Future<Response> postRequestComment(
      String url, Map<String, dynamic> data) async {
    try {
      final formData = FormData.fromMap(data);
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'ngrok-skip-browser-warning': 'true'
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Allow all status codes below 500
          },
        ),
      );
      final formDataNew = FormData.fromMap(data);

      response = await _handleRedirect(response, formDataNew);
      return response;
    } catch (e) {
      throw Exception('POST request error: $e');
    }
  }

  Future<Response> patchRequestUser(String url, String data) async {
    try {
      Response response = await dio.patch(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500; // Allow all status codes below 500
          },
        ),
      );

      response = await _handleRedirectPath(response, data);
      return response;
    } catch (e) {
      throw Exception('PATCH request error: $e');
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
