import '../model/food_campaign_model.dart';

abstract class FoodCampaignRepositoryInterface {
  Future<List<FoodCampaignModel>> getFoodCampaigns();
}
