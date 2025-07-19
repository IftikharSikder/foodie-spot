import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../domain/model/food_campaign_model.dart';
import '../domain/service/food_campaign_service_interface.dart';

class FoodCampaignController with ChangeNotifier {
  final FoodCampaignServiceInterface _service;

  List<FoodCampaignModel> _campaigns = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _hasConnection = true;

  FoodCampaignController({required FoodCampaignServiceInterface service})
    : _service = service {
    _initConnectivity();
  }

  List<FoodCampaignModel> get campaigns => _campaigns;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get hasConnection => _hasConnection;

  void _initConnectivity() {
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      bool previousConnection = _hasConnection;
      _hasConnection = results.any(
        (result) => result != ConnectivityResult.none,
      );

      if (_hasConnection && !previousConnection) {
        getFoodCampaigns();
      }
      notifyListeners();
    });
  }

  Future<void> getFoodCampaigns() async {
    if (!_hasConnection) {
      _isLoading = true;
      _hasError = false;
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      final campaigns = await _service.getFoodCampaigns();
      _campaigns = campaigns;
      _isLoading = false;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> refreshCampaigns() async {
    await getFoodCampaigns();
  }
}
