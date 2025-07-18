import '../models/category_model.dart';

abstract class CategoryRepositoryInterface {
  Future<List<CategoryModel>> getCategories();
  Future<List<CategoryModel>> getCategoryProducts(int categoryId);
}
