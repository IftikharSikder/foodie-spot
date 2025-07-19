import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../domain/models/popular_food_model.dart';
import '../domain/repository/popular_food_repository_interface.dart';

class PopularFoodController extends ChangeNotifier {
  final PopularFoodRepositoryInterface _popularFoodRepository;

  PopularFoodController(this._popularFoodRepository) {
    _connectivitySubscription = Connectivity().onConnectivityChanged
        .map((results) => results.first)
        .listen((result) {
          if (result != ConnectivityResult.none && _hasNetworkError) {
            retryOnConnectivityRestored();
          }
        });
  }

  List<PopularFoodModel> _popularFoods = [];
  bool _isLoading = false;
  String _error = '';
  bool _hasNetworkError = false;

  List<PopularFoodModel> get popularFoods => _popularFoods;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasNetworkError => _hasNetworkError;

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  Future<void> getPopularFoods() async {
    try {
      _isLoading = true;
      _error = '';
      _hasNetworkError = false;
      notifyListeners();

      final foods = await _popularFoodRepository.getPopularFoods();
      _popularFoods = foods;
    } catch (e) {
      _error = e.toString();
      _hasNetworkError = _isNetworkError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retryOnConnectivityRestored() async {
    if (_hasNetworkError && _error.isNotEmpty) {
      await getPopularFoods();
    }
  }

  Future<void> silentRetry() async {
    if (_hasNetworkError && _error.isNotEmpty) {
      try {
        final foods = await _popularFoodRepository.getPopularFoods();
        _popularFoods = foods;
        _error = '';
        _hasNetworkError = false;
        notifyListeners();
      } catch (e) {
        _error = e.toString();
        _hasNetworkError = _isNetworkError(e);
      }
    }
  }

  bool _isNetworkError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    return errorString.contains('socketexception') ||
        errorString.contains('failed host lookup') ||
        errorString.contains('no address associated with hostname') ||
        errorString.contains('clientexception') ||
        errorString.contains('name not resolved') ||
        errorString.contains('network is unreachable') ||
        errorString.contains('connection refused') ||
        errorString.contains('unable to resolve host');
  }

  void clearError() {
    _error = '';
    _hasNetworkError = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
