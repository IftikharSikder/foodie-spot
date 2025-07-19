class BannerModel {
  final int id;
  final String title;
  final String type;
  final String image;
  final String imageFullUrl;
  final RestaurantModel? restaurant;
  final FoodModel? food;
  final String? redirectUrl;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BannerModel({
    required this.id,
    required this.title,
    required this.type,
    required this.image,
    required this.imageFullUrl,
    this.restaurant,
    this.food,
    this.redirectUrl,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    String imageUrl = json['image'] ?? '';
    String fullImageUrl = '';
    if (imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http')) {
        fullImageUrl = imageUrl;
      } else {
        fullImageUrl =
            'https://stackfood-admin.6amtech.com/storage/app/public/banner/$imageUrl';
      }
    }

    return BannerModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      image: imageUrl,
      imageFullUrl: fullImageUrl,
      restaurant: json['restaurant'] != null
          ? RestaurantModel.fromJson(json['restaurant'])
          : null,
      food: json['food'] != null ? FoodModel.fromJson(json['food']) : null,
      redirectUrl: json['redirect_url'],
      isActive: json['status'] == 1,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'image': image,
      'image_full_url': imageFullUrl,
      'restaurant': restaurant?.toJson(),
      'food': food?.toJson(),
      'redirect_url': redirectUrl,
      'status': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get description => restaurant?.name ?? food?.name ?? title;
  int? get restaurantId => restaurant?.id;
  int? get foodId => food?.id;
}

class RestaurantModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String? logo;
  final String? coverPhoto;
  final String address;
  final double? latitude;
  final double? longitude;
  final bool delivery;
  final bool takeAway;
  final int status;
  final String? deliveryTime;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.logo,
    this.coverPhoto,
    required this.address,
    this.latitude,
    this.longitude,
    required this.delivery,
    required this.takeAway,
    required this.status,
    this.deliveryTime,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      logo: json['logo'],
      coverPhoto: json['cover_photo'],
      address: json['address'] ?? '',
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      delivery: json['delivery'] ?? false,
      takeAway: json['take_away'] ?? false,
      status: json['status'] ?? 0,
      deliveryTime: json['delivery_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'logo': logo,
      'cover_photo': coverPhoto,
      'address': address,
      'latitude': latitude?.toString(),
      'longitude': longitude?.toString(),
      'delivery': delivery,
      'take_away': takeAway,
      'status': status,
      'delivery_time': deliveryTime,
    };
  }
}

class FoodModel {
  final int id;
  final String name;
  final String? description;
  final String? image;
  final double price;
  final int categoryId;
  final int restaurantId;

  FoodModel({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.price,
    required this.categoryId,
    required this.restaurantId,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      image: json['image'],
      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
      categoryId: json['category_id'] ?? 0,
      restaurantId: json['restaurant_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'category_id': categoryId,
      'restaurant_id': restaurantId,
    };
  }
}

class BannerResponse {
  final List<BannerModel> banners;
  final List<BannerModel> campaigns;
  final bool success;
  final String message;

  BannerResponse({
    required this.banners,
    required this.campaigns,
    required this.success,
    required this.message,
  });

  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    return BannerResponse(
      banners:
          (json['banners'] as List?)
              ?.map((item) => BannerModel.fromJson(item))
              .toList() ??
          [],
      campaigns:
          (json['campaigns'] as List?)
              ?.map((item) => BannerModel.fromJson(item))
              .toList() ??
          [],
      success:
          true,
      message: 'Success',
    );
  }

  List<BannerModel> get allBanners => [...banners, ...campaigns];
}
