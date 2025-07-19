class FoodCampaignModel {
  final int id;
  final String name;
  final String description;
  final String image;
  final String imageFullUrl;
  final double price;
  final double discount;
  final String discountType;
  final double avgRating;
  final int ratingCount;
  final String restaurantName;
  final int restaurantId;
  final bool isActive;
  final bool veg;
  final String availableTimeStarts;
  final String availableTimeEnds;

  FoodCampaignModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.imageFullUrl,
    required this.price,
    required this.discount,
    required this.discountType,
    required this.avgRating,
    required this.ratingCount,
    required this.restaurantName,
    required this.restaurantId,
    required this.isActive,
    required this.veg,
    required this.availableTimeStarts,
    required this.availableTimeEnds,
  });

  factory FoodCampaignModel.fromJson(Map<String, dynamic> json) {
    return FoodCampaignModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      imageFullUrl: json['image_full_url'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0.0).toDouble(),
      discountType: json['discount_type'] ?? 'percent',
      avgRating: (json['avg_rating'] ?? 0.0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      restaurantName: json['restaurant_name'] ?? '',
      restaurantId: json['restaurant_id'] ?? 0,
      isActive: json['status'] == 1,
      veg: json['veg'] == 1,
      availableTimeStarts: json['available_time_starts'] ?? '',
      availableTimeEnds: json['available_time_ends'] ?? '',
    );
  }

  double get discountedPrice {
    if (discountType == 'percent') {
      return price - (price * discount / 100);
    } else {
      return price - discount;
    }
  }

  int get discountPercentage {
    if (discountType == 'percent') {
      return discount.toInt();
    } else {
      return ((discount / price) * 100).toInt();
    }
  }
}
