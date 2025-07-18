import '../model/food_campaign_model.dart';

abstract class FoodCampaignServiceInterface {
  Future<List<FoodCampaignModel>> getFoodCampaigns();
}
