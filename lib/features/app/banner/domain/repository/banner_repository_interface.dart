import '../models/banner_model.dart';

abstract class BannerRepositoryInterface {
  Future<BannerResponse> getAllBanners();
  Future<BannerModel?> getBannerById(int id);
}
