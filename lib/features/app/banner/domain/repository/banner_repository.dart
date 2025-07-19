import 'package:dio/dio.dart';

import '../models/banner_model.dart';
import 'banner_repository_interface.dart';

class BannerRepository implements BannerRepositoryInterface {
  final Dio _dio;

  BannerRepository({Dio? dio}) : _dio = dio ?? _createDio();

  static Dio _createDio() {
    final dio = Dio();
    dio.options.baseUrl = 'https://stackfood-admin.6amtech.com/api/v1';
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers.addAll({
      'Content-Type': 'application/json; charset=UTF-8',
      'zoneId': '[1]',
      'latitude': '23.735129',
      'longitude': '90.425614',
    });

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return dio;
  }

  @override
  Future<BannerResponse> getAllBanners() async {
    try {
      final response = await _dio.get('/banners');

      if (response.statusCode == 200) {
        return BannerResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch banners',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<BannerModel?> getBannerById(int id) async {
    try {
      final response = await _dio.get('/banners/$id');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['banner'] != null) {
          return BannerModel.fromJson(data['banner']);
        }
        return null;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch banner',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.sendTimeout:
        return Exception('Send timeout');
      case DioExceptionType.receiveTimeout:
        return Exception('Receive timeout');
      case DioExceptionType.badResponse:
        return Exception('Server error: ${e.response?.statusCode}');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      case DioExceptionType.unknown:
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
