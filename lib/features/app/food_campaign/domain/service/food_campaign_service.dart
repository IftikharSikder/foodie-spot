import '../model/food_campaign_model.dart';
import '../repository/food_campaign_repository_interface.dart';
import 'food_campaign_service_interface.dart';

class FoodCampaignService implements FoodCampaignServiceInterface {
  final FoodCampaignRepositoryInterface _repository;

  FoodCampaignService({required FoodCampaignRepositoryInterface repository})
    : _repository = repository;

  @override
  Future<List<FoodCampaignModel>> getFoodCampaigns() async {
    return await _repository.getFoodCampaigns();
  }
}
