import '../models/popular_food_model.dart';

abstract class PopularFoodRepositoryInterface {
  Future<List<PopularFoodModel>> getPopularFoods();
}
