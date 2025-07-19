import 'package:flutter/material.dart';

import '../domain/models/restaurant_model.dart';
import '../domain/service/api_service.dart';

class RestaurantController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Restaurant> _restaurants = [];
  List<Restaurant> _filteredRestaurants = [];
  List<Food> _allFoods = [];
  List<Food> _filteredFoods = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String _errorMessage = '';
  String _searchQuery = '';
  Restaurant? _selectedRestaurant;
  Food? _selectedFood;

  String _selectedSortOption = 'All';
  String _selectedTab = 'All';
  final List<String> _sortOptions = [
    'All',
    'Top Rated',
    'Nearest',
    'Open Now',
    'Popular',
    'Free Delivery',
  ];

  List<Restaurant> get restaurants => _restaurants;
  List<Restaurant> get filteredRestaurants => _filteredRestaurants;
  List<Food> get allFoods => _allFoods;
  List<Food> get filteredFoods => _filteredFoods;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  Restaurant? get selectedRestaurant => _selectedRestaurant;
  Food? get selectedFood => _selectedFood;
  String get selectedSortOption => _selectedSortOption;
  String get selectedTab => _selectedTab;
  List<String> get sortOptions => _sortOptions;

  Future<void> initializeData() async {
    await fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _apiService.getRestaurants(offset: 0, limit: 20);
      _restaurants = response.restaurants;
      _filteredRestaurants = List.from(_restaurants);

      _allFoods = [];
      for (var restaurant in _restaurants) {
        for (var food in restaurant.foods) {
          _allFoods.add(food);
        }
      }
      _filteredFoods = List.from(_allFoods);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void searchRestaurantsAndFoods(String query) {
    _searchQuery = query;
    _isSearching = query.isNotEmpty;

    if (query.isEmpty) {
      _filteredRestaurants = List.from(_restaurants);
      _filteredFoods = List.from(_allFoods);
    } else {
      _filteredRestaurants = _restaurants.where((restaurant) {
        return restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
            restaurant.address.toLowerCase().contains(query.toLowerCase()) ||
            restaurant.cuisine.any(
              (cuisine) =>
                  cuisine.name.toLowerCase().contains(query.toLowerCase()),
            );
      }).toList();

      _filteredFoods = _allFoods.where((food) {
        return food.name.toLowerCase().contains(query.toLowerCase()) ||
            food.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    notifyListeners();
  }

  void setSortOption(String option) {
    _selectedSortOption = option;
    notifyListeners();
  }

  void setSelectedTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  List<Restaurant> getSortedRestaurants() {
    List<Restaurant> restaurantsToSort = _isSearching
        ? _filteredRestaurants
        : _restaurants;
    List<Restaurant> sortedList = List.from(restaurantsToSort);

    switch (_selectedSortOption) {
      case 'Top Rated':
        sortedList.sort((a, b) => b.avgRating.compareTo(a.avgRating));
        break;
      case 'Nearest':
        sortedList.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case 'Open Now':
        sortedList = sortedList.where((restaurant) => restaurant.open).toList();
        break;
      case 'Popular':
        sortedList.sort((a, b) => b.orderCount.compareTo(a.orderCount));
        break;
      case 'Free Delivery':
        sortedList = sortedList
            .where(
              (restaurant) =>
                  restaurant.deliveryFee == '0' ||
                  restaurant.deliveryFee.isEmpty,
            )
            .toList();
        break;
      default:
        break;
    }

    return sortedList;
  }

  List<Food> getFoodsFromSortedRestaurants() {
    List<Restaurant> sortedRestaurants = getSortedRestaurants();
    List<Food> foodsFromSortedRestaurants = [];

    for (var restaurant in sortedRestaurants) {
      foodsFromSortedRestaurants.addAll(restaurant.foods);
    }

    return foodsFromSortedRestaurants;
  }

  Restaurant? getRestaurantForFood(Food food) {
    return _restaurants.firstWhere(
      (restaurant) => restaurant.foods.any((f) => f.id == food.id),
      orElse: () => _restaurants.first,
    );
  }

  void selectRestaurant(Restaurant restaurant) {
    _selectedRestaurant = restaurant;
    _selectedFood = null;
    notifyListeners();
  }

  void selectFood(Food food) {
    _selectedFood = food;
    _selectedRestaurant = _restaurants.firstWhere(
      (restaurant) => restaurant.foods.any((f) => f.id == food.id),
      orElse: () => _restaurants.first,
    );
    notifyListeners();
  }

  void clearSelection() {
    _selectedRestaurant = null;
    _selectedFood = null;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _isSearching = false;
    _filteredRestaurants = List.from(_restaurants);
    _filteredFoods = List.from(_allFoods);
    notifyListeners();
  }

  Restaurant? getRestaurantById(int id) {
    try {
      return _restaurants.firstWhere((restaurant) => restaurant.id == id);
    } catch (e) {
      return null;
    }
  }

  Food? getFoodById(int id) {
    try {
      return _allFoods.firstWhere((food) => food.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Food> getFoodsByRestaurant(int restaurantId) {
    final restaurant = getRestaurantById(restaurantId);
    return restaurant?.foods ?? [];
  }

  Future<void> refreshData() async {
    await fetchRestaurants();
  }

  Future<void> loadMoreRestaurants() async {
    if (_isLoading) return;

    try {
      final response = await _apiService.getRestaurants(
        offset: _restaurants.length,
        limit: 10,
      );

      _restaurants.addAll(response.restaurants);

      for (var restaurant in response.restaurants) {
        for (var food in restaurant.foods) {
          _allFoods.add(food);
        }
      }

      if (!_isSearching) {
        _filteredRestaurants = List.from(_restaurants);
        _filteredFoods = List.from(_allFoods);
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
