import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/models/popular_food_model.dart';
import '../domain/repository/popular_food_repository_interface.dart';

class PopularFoodController extends ChangeNotifier {
  final PopularFoodRepositoryInterface _popularFoodRepository;

  PopularFoodController(this._popularFoodRepository);

  List<PopularFoodModel> _popularFoods = [];
  bool _isLoading = false;
  String _error = '';
  bool _hasNetworkError = false;

  List<PopularFoodModel> get popularFoods => _popularFoods;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasNetworkError => _hasNetworkError;

  Future<void> getPopularFoods() async {
    _isLoading = true;
    _error = '';
    _hasNetworkError = false;
    notifyListeners();

    try {
      _popularFoods = await _popularFoodRepository.getPopularFoods();
      _error = '';
      _hasNetworkError = false;
    } catch (e) {
      _error = e.toString();
      _hasNetworkError = _isNetworkError(e.toString());

      // Only clear the list if we don't have cached data and it's not a network error
      if (_popularFoods.isEmpty || !_hasNetworkError) {
        _popularFoods = [];
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to be called when internet is restored
  Future<void> retryOnConnectivityRestored() async {
    if (_hasNetworkError && _error.isNotEmpty) {
      await getPopularFoods();
    }
  }

  // Method to silently retry without showing loading state
  Future<void> silentRetry() async {
    if (_hasNetworkError && _error.isNotEmpty) {
      try {
        final foods = await _popularFoodRepository.getPopularFoods();
        _popularFoods = foods;
        _error = '';
        _hasNetworkError = false;
        notifyListeners();
      } catch (e) {
        // Keep the existing error state
        _error = e.toString();
        _hasNetworkError = _isNetworkError(e.toString());
      }
    }
  }

  bool _isNetworkError(String error) {
    final networkErrors = [
      'no internet',
      'network error',
      'connection failed',
      'timeout',
      'unreachable',
      'offline',
      'connection timeout',
      'socket',
      'failed to connect',
      'network is unreachable',
      'connection timed out',
    ];

    return networkErrors.any(
      (networkError) => error.toLowerCase().contains(networkError),
    );
  }

  void clearError() {
    _error = '';
    _hasNetworkError = false;
    notifyListeners();
  }
}
