import '../models/popular_food_model.dart';
import '../repository/popular_food_repository.dart';
import '../repository/popular_food_repository_interface.dart';

class PopularFoodService {
  final PopularFoodRepositoryInterface _popularFoodRepository;

  PopularFoodService({PopularFoodRepositoryInterface? popularFoodRepository})
    : _popularFoodRepository = popularFoodRepository ?? PopularFoodRepository();

  Future<List<PopularFoodModel>> getPopularFoods() async {
    return await _popularFoodRepository.getPopularFoods();
  }
}
