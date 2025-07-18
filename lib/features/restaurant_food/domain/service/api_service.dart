import 'package:dio/dio.dart';

import '../models/restaurant_model.dart';

class ApiService {
  late Dio _dio;
  static const String baseUrl = 'https://stackfood-admin.6amtech.com/api/v1';

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'zoneId': '[1]',
          'latitude': '23.735129',
          'longitude': '90.425614',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
      ),
    );
  }

  Future<RestaurantResponse> getRestaurants({
    int offset = 0,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/restaurants/get-restaurants/all',
        queryParameters: {'offset': offset, 'limit': limit},
      );

      if (response.statusCode == 200) {
        return RestaurantResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load restaurants: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<Restaurant?> getRestaurantById(int id) async {
    try {
      final response = await _dio.get('/restaurants/details/$id');

      if (response.statusCode == 200) {
        return Restaurant.fromJson(response.data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load restaurant details: $e');
    }
  }

  Future<List<Food>> getFoodsByRestaurant(int restaurantId) async {
    try {
      final response = await _dio.get('/restaurants/$restaurantId/foods');

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((item) => Food.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load foods: $e');
    }
  }
}
