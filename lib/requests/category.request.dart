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
}
