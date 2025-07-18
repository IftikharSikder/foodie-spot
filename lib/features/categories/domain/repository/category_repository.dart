import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/api_config.dart';
import '../models/category_model.dart';
import 'category_repository_interface.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/categories'),
            headers: ApiConfig.headers,
          )
          .timeout(Duration(milliseconds: ApiConfig.connectTimeout));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategoryProducts(int categoryId) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/categories/$categoryId/products'),
            headers: ApiConfig.headers,
          )
          .timeout(Duration(milliseconds: ApiConfig.connectTimeout));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load category products: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching category products: $e');
    }
  }
}
