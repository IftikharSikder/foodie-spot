import 'package:flutter/foundation.dart';

import '../domain/models/category_model.dart';
import '../domain/service/category_service_interface.dart';

class CategoryController extends ChangeNotifier {
  final CategoryServiceInterface _categoryService;

  CategoryController(this._categoryService) {
    _initializeCategories();
  }

  List<CategoryModel> _categories = [];
  List<CategoryModel> _categoryProducts = [];
  CategoryModel? _selectedCategory;
  bool _isLoading = false;
  bool _isProductsLoading = false;
  String _error = '';

  List<CategoryModel> get categories => _categories;
  List<CategoryModel> get categoryProducts => _categoryProducts;
  CategoryModel? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  bool get isProductsLoading => _isProductsLoading;
  String get error => _error;

  List<CategoryModel> get parentCategories =>
      _categoryService.getParentCategories(_categories);

  List<CategoryModel> getSubCategories(int parentId) =>
      _categoryService.getSubCategories(_categories, parentId);

  Future<void> _initializeCategories() async {
    await fetchCategories();
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _categories = await _categoryService.getAllCategories();
      _error = '';
    } catch (e) {
      _error = e.toString();
      _categories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategoryProducts(int categoryId) async {
    _isProductsLoading = true;
    _error = '';
    notifyListeners();

    try {
      _categoryProducts = await _categoryService.getCategoryProducts(
        categoryId,
      );
      _error = '';
    } catch (e) {
      _error = e.toString();
      _categoryProducts = [];
    } finally {
      _isProductsLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(CategoryModel category) {
    if (_selectedCategory?.id != category.id) {
      _selectedCategory = category;
      notifyListeners();

      fetchCategoryProducts(category.id);
    }
  }

  void clearSelection() {
    _selectedCategory = null;
    _categoryProducts = [];
    notifyListeners();
  }

  void refresh() {
    fetchCategories();
    if (_selectedCategory != null) {
      fetchCategoryProducts(_selectedCategory!.id);
    }
  }
}
