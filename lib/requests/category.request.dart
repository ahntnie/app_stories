import 'dart:convert';

import 'package:dio/dio.dart';

import '../constants/api.dart';
import '../models/category_model.dart';

class CategoryRequest {
  Dio dio = Dio();

  Future<List<Category>> getCategories() async {
    List<Category> categories = [];
    final response = await dio.get('${Api.hostApi}${Api.getCategories}');
    final responseData = jsonDecode(jsonEncode(response.data));
    List<dynamic> lstCategory = responseData['data'];
    categories = lstCategory.map((e) => Category.fromJson(e)).toList();
    return categories;
  }

  Future<void> addCategory(String name, String desc) async {
    final response = await dio.post('${Api.hostApi}${Api.addCategories}',
        queryParameters: {"name": name, "description": desc});
    print('Body thêm thể loại: ${response.data}');
  }

  Future<void> deleteCategory(int id) async {
    final response =
        await dio.delete('${Api.hostApi}${Api.deleteCategories}/$id');
    print('Body xóa thể loại: ${response.data}');
  }

  Future<int> getCountNewUsers(String type) async {
    int count = 0;
    final response = await dio
        .get('${Api.hostApi}${Api.getCountNewUsers}', queryParameters: {
      "time_period": type,
    });
    print('Body số lượng new user: ${response.data}');
    final responseData = response.data;
    count = responseData['new_users_count'];
    return count;
  }
}
