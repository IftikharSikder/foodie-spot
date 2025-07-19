import '../models/category_model.dart';

abstract class CategoryServiceInterface {
  Future<List<CategoryModel>> getAllCategories();
  Future<List<CategoryModel>> getCategoryProducts(int categoryId);
  List<CategoryModel> getParentCategories(List<CategoryModel> categories);
  List<CategoryModel> getSubCategories(
    List<CategoryModel> categories,
    int parentId,
  );
}
