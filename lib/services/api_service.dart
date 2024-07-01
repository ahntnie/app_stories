import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();

  ApiService() {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  Future<Response> _handleRedirect(Response response, FormData formData) async {
    if (response.statusCode == 302) {
      print('vo 302');
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

  Future<Response> postRequest(String url, Map<String, dynamic> data) async {
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

  Future<Response> patchRequest(String url, String data) async {
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
