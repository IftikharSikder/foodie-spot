// lib/domain/service/banner_service.dart
import '../models/banner_model.dart';
import '../repository/banner_repository_interface.dart';
import 'banner_service_interface.dart';

class BannerService implements BannerServiceInterface {
  final BannerRepositoryInterface _bannerRepository;

  BannerService({required BannerRepositoryInterface bannerRepository})
    : _bannerRepository = bannerRepository;

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      final response = await _bannerRepository.getAllBanners();

      print('Regular banners count: ${response.banners.length}');

      return response.allBanners;
    } catch (e) {
      throw Exception('Failed to fetch banners: $e');
    }
  }

  @override
  Future<BannerModel?> getBannerDetails(int id) async {
    try {
      return await _bannerRepository.getBannerById(id);
    } catch (e) {
      throw Exception('Failed to fetch banner details: $e');
    }
  }

  @override
  void handleBannerClick(BannerModel banner) {
    // Handle banner click logic
    print('Banner clicked: ${banner.title}');
    print('Banner type: ${banner.type}');
    print('Restaurant: ${banner.restaurant?.name}');
    print('Food: ${banner.food?.name}');

    // You can add navigation logic here based on banner type
    switch (banner.type) {
      case 'restaurant_wise':
        // Navigate to restaurant details
        if (banner.restaurant != null) {
          print('Navigate to restaurant: ${banner.restaurant!.name}');
        }
        break;
      case 'food_wise':
        // Navigate to food details
        if (banner.food != null) {
          print('Navigate to food: ${banner.food!.name}');
        }
        break;
      case 'default':
        // Default banner action
        print('Default banner action');
        break;
      default:
        // Default action
        print('Unknown banner type: ${banner.type}');
        break;
    }
  }
}
