import '../models/banner_model.dart';

abstract class BannerServiceInterface {
  Future<List<BannerModel>> getBanners();
  Future<BannerModel?> getBannerDetails(int id);
  void handleBannerClick(BannerModel banner);
}
