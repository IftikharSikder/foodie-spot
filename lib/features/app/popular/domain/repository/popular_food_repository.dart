import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../core/config/api_config.dart';
import '../../domain/models/popular_food_model.dart';
import 'popular_food_repository_interface.dart';

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

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List<dynamic> products = data['products'] ?? [];

        final List<PopularFoodModel> popularFoods = products.map((product) {
          try {
            return PopularFoodModel.fromJson(product);
          } catch (e) {
            rethrow;
          }
        }).toList();

        return popularFoods;
      } else {
        throw Exception(
          'Failed to load popular foods. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching popular foods: $e');
    }
  }
}
