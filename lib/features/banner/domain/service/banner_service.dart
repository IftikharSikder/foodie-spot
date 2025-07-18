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
    switch (banner.type) {
      case 'restaurant_wise':
        if (banner.restaurant != null) {
          print('Navigate to restaurant: ${banner.restaurant!.name}');
        }
        break;
      case 'food_wise':
        if (banner.food != null) {
          print('Navigate to food: ${banner.food!.name}');
        }
        break;
      case 'default':
        print('Default banner action');
        break;
      default:
        print('Unknown banner type: ${banner.type}');
        break;
    }
  }
}
