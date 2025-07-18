import '../models/category_model.dart';
import '../repository/category_repository_interface.dart';
import 'category_service_interface.dart';

class CategoryService implements CategoryServiceInterface {
  final CategoryRepositoryInterface _categoryRepository;

  CategoryService(this._categoryRepository);

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    return await _categoryRepository.getCategories();
  }

  @override
  Future<List<CategoryModel>> getCategoryProducts(int categoryId) async {
    return await _categoryRepository.getCategoryProducts(categoryId);
  }

  @override
  List<CategoryModel> getParentCategories(List<CategoryModel> categories) {
    return categories.where((category) => category.parentId == 0).toList();
  }

  @override
  List<CategoryModel> getSubCategories(
    List<CategoryModel> categories,
    int parentId,
  ) {
    return categories
        .where((category) => category.parentId == parentId)
        .toList();
  }
}
