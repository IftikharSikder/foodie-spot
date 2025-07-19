import '../models/popular_food_model.dart';

abstract class PopularFoodServiceInterface {
  Future<List<PopularFoodModel>> getPopularFoods();
}
