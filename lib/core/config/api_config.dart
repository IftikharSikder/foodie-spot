// lib/core/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'https://stackfood-admin.6amtech.com/api/v1';
  static const String bannersEndpoint = '/banners';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'zoneId': '[1]',
    'latitude': '23.735129',
    'longitude': '90.425614',
  };
}
