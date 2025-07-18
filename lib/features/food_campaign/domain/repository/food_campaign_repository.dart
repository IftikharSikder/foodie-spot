import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../model/food_campaign_model.dart';
import 'food_campaign_repository_interface.dart';

class FoodCampaignRepository implements FoodCampaignRepositoryInterface {
  final Dio _dio;

  FoodCampaignRepository({required Dio dio}) : _dio = dio;

  @override
  Future<List<FoodCampaignModel>> getFoodCampaigns() async {
    try {
      final response = await _dio.get(
        '${ApiConfig.baseUrl}/campaigns/item',
        options: Options(
          headers: ApiConfig.headers,
          sendTimeout: Duration(milliseconds: ApiConfig.connectTimeout),
          receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> campaignData = response.data as List<dynamic>;
        return campaignData
            .map((item) => FoodCampaignModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load food campaigns');
      }
    } catch (e) {
      throw Exception('Error fetching food campaigns: $e');
    }
  }
}
