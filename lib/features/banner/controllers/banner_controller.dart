import 'package:flutter/material.dart';

import '../domain/models/banner_model.dart';
import '../domain/service/banner_service_interface.dart';

class BannerController extends ChangeNotifier {
  final BannerServiceInterface _bannerService;

  BannerController({required BannerServiceInterface bannerService})
    : _bannerService = bannerService;

  List<BannerModel> _banners = [];
  bool _isLoading = false;
  String _error = '';
  int _currentIndex = 0;

  List<BannerModel> get banners => _banners;
  bool get isLoading => _isLoading;
  String get error => _error;
  int get currentIndex => _currentIndex;

  Future<void> fetchBanners() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _banners = await _bannerService.getBanners();
      _error = '';
    } catch (e) {
      _error = e.toString();
      _banners = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void handleBannerClick(BannerModel banner) {
    _bannerService.handleBannerClick(banner);
  }

  void refreshBanners() {
    fetchBanners();
  }
}
