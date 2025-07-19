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
    switch (banner.type) {
      case 'restaurant_wise':
        if (banner.restaurant != null) {}
        break;
      case 'food_wise':
        if (banner.food != null) {}
        break;
      case 'default':
        break;
      default:
        break;
    }
  }
}
