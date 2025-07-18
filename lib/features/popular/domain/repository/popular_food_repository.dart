import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/api_config.dart';
import '../../domain/models/popular_food_model.dart';
import '../../domain/repository/popular_food_repository_interface.dart';

class PopularFoodRepository implements PopularFoodRepositoryInterface {
  @override
  Future<List<PopularFoodModel>> getPopularFoods() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/products/popular'),
            headers: ApiConfig.headers,
          )
          .timeout(const Duration(milliseconds: ApiConfig.connectTimeout));

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Parsed data: $data');

        final List<dynamic> products = data['products'] ?? [];
        print('Products count: ${products.length}');

        if (products.isNotEmpty) {
          print('First product: ${products[0]}');
        }

        final List<PopularFoodModel> popularFoods = products.map((product) {
          try {
            return PopularFoodModel.fromJson(product);
          } catch (e) {
            print('Error parsing product: $product');
            print('Error: $e');
            rethrow;
          }
        }).toList();

        print('Successfully parsed ${popularFoods.length} popular foods');
        return popularFoods;
      } else {
        throw Exception(
          'Failed to load popular foods. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Exception in getPopularFoods: $e');
      throw Exception('Error fetching popular foods: $e');
    }
  }
}
