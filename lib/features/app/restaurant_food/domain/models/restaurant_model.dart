class RestaurantResponse {
  final String filterData;
  final int totalSize;
  final String limit;
  final String offset;
  final List<Restaurant> restaurants;

  RestaurantResponse({
    required this.filterData,
    required this.totalSize,
    required this.limit,
    required this.offset,
    required this.restaurants,
  });

  factory RestaurantResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantResponse(
      filterData: json['filter_data'] ?? '',
      totalSize: json['total_size'] ?? 0,
      limit: json['limit'] ?? '',
      offset: json['offset'] ?? '',
      restaurants:
          (json['restaurants'] as List<dynamic>?)
              ?.map((item) => Restaurant.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Restaurant {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String logo;
  final String latitude;
  final String longitude;
  final String address;
  final bool delivery;
  final bool takeAway;
  final String deliveryTime;
  final int orderCount;
  final int totalOrder;
  final double avgRating;
  final int ratingCount;
  final bool open;
  final double distance;
  final int foodsCount;
  final List<Food> foods;
  final List<Coupon> coupons;
  final String deliveryFee;
  final List<Cuisine> cuisine;
  final String logoFullUrl;
  final String coverPhotoFullUrl;
  final String? announcementMessage;

  Restaurant({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.logo,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.delivery,
    required this.takeAway,
    required this.deliveryTime,
    required this.orderCount,
    required this.totalOrder,
    required this.avgRating,
    required this.ratingCount,
    required this.open,
    required this.distance,
    required this.foodsCount,
    required this.foods,
    required this.coupons,
    required this.deliveryFee,
    required this.cuisine,
    required this.logoFullUrl,
    required this.coverPhotoFullUrl,
    this.announcementMessage,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      logo: json['logo'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      address: json['address'] ?? '',
      delivery: json['delivery'] ?? false,
      takeAway: json['take_away'] ?? false,
      deliveryTime: json['delivery_time'] ?? '',
      orderCount: json['order_count'] ?? 0,
      totalOrder: json['total_order'] ?? 0,
      avgRating: (json['avg_rating'] ?? 0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      open: json['open'] == 1,
      distance: (json['distance'] ?? 0).toDouble(),
      foodsCount: json['foods_count'] ?? 0,
      foods:
          (json['foods'] as List<dynamic>?)
              ?.map((item) => Food.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      coupons:
          (json['coupons'] as List<dynamic>?)
              ?.map((item) => Coupon.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      deliveryFee: json['delivery_fee'] ?? '',
      cuisine:
          (json['cuisine'] as List<dynamic>?)
              ?.map((item) => Cuisine.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      logoFullUrl: json['logo_full_url'] ?? '',
      coverPhotoFullUrl: json['cover_photo_full_url'] ?? '',
      announcementMessage: json['announcement_message'],
    );
  }
}

class Food {
  final int id;
  final String image;
  final String name;
  final String imageFullUrl;
  final List<Translation> translations;

  Food({
    required this.id,
    required this.image,
    required this.name,
    required this.imageFullUrl,
    required this.translations,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      imageFullUrl: json['image_full_url'] ?? '',
      translations:
          (json['translations'] as List<dynamic>?)
              ?.map(
                (item) => Translation.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  String get description {
    final descTranslation = translations.firstWhere(
      (t) => t.key == 'description',
      orElse: () => Translation(id: 0, key: '', value: ''),
    );
    return descTranslation.value;
  }
}

class Translation {
  final int id;
  final String key;
  final String value;

  Translation({required this.id, required this.key, required this.value});

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json['id'] ?? 0,
      key: json['key'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

class Coupon {
  final int id;
  final String title;
  final String code;
  final String startDate;
  final String expireDate;
  final int minPurchase;
  final int maxDiscount;
  final int discount;
  final String discountType;

  Coupon({
    required this.id,
    required this.title,
    required this.code,
    required this.startDate,
    required this.expireDate,
    required this.minPurchase,
    required this.maxDiscount,
    required this.discount,
    required this.discountType,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      code: json['code'] ?? '',
      startDate: json['start_date'] ?? '',
      expireDate: json['expire_date'] ?? '',
      minPurchase: json['min_purchase'] ?? 0,
      maxDiscount: json['max_discount'] ?? 0,
      discount: json['discount'] ?? 0,
      discountType: json['discount_type'] ?? '',
    );
  }
}

class Cuisine {
  final int id;
  final String name;
  final String image;
  final String imageFullUrl;

  Cuisine({
    required this.id,
    required this.name,
    required this.image,
    required this.imageFullUrl,
  });

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      imageFullUrl: json['image_full_url'] ?? '',
    );
  }
}
