class PopularFoodModel {
  final int id;
  final String name;
  final String description;
  final String image;
  final int categoryId;
  final List<CategoryModel> categories;
  final List<VariationModel> variations;
  final List<AddOnModel> addOns;
  final double price;
  final double tax;
  final String taxType;
  final double discount;
  final String discountType;
  final String availableTimeStarts;
  final String availableTimeEnds;
  final int veg;
  final int status;
  final int restaurantId;
  final String createdAt;
  final String updatedAt;
  final int orderCount;
  final double avgRating;
  final int ratingCount;
  final int recommended;
  final String slug;
  final int? maximumCartQuantity;
  final int isHalal;
  final int itemStock;
  final int sellCount;
  final String stockType;
  final int tempAvailable;
  final int open;
  final int reviewsCount;
  final List<String> tags;
  final String restaurantName;
  final int restaurantStatus;
  final double restaurantDiscount;
  final String? restaurantOpeningTime;
  final String? restaurantClosingTime;
  final bool scheduleOrder;
  final int minDeliveryTime;
  final int maxDeliveryTime;
  final int freeDelivery;
  final int halalTagStatus;
  final List<String> nutritionsName;
  final List<String> allergiesName;
  final List<CategoryModel> cuisines;
  final String imageFullUrl;

  PopularFoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.categoryId,
    required this.categories,
    required this.variations,
    required this.addOns,
    required this.price,
    required this.tax,
    required this.taxType,
    required this.discount,
    required this.discountType,
    required this.availableTimeStarts,
    required this.availableTimeEnds,
    required this.veg,
    required this.status,
    required this.restaurantId,
    required this.createdAt,
    required this.updatedAt,
    required this.orderCount,
    required this.avgRating,
    required this.ratingCount,
    required this.recommended,
    required this.slug,
    this.maximumCartQuantity,
    required this.isHalal,
    required this.itemStock,
    required this.sellCount,
    required this.stockType,
    required this.tempAvailable,
    required this.open,
    required this.reviewsCount,
    required this.tags,
    required this.restaurantName,
    required this.restaurantStatus,
    required this.restaurantDiscount,
    this.restaurantOpeningTime,
    this.restaurantClosingTime,
    required this.scheduleOrder,
    required this.minDeliveryTime,
    required this.maxDeliveryTime,
    required this.freeDelivery,
    required this.halalTagStatus,
    required this.nutritionsName,
    required this.allergiesName,
    required this.cuisines,
    required this.imageFullUrl,
  });

  factory PopularFoodModel.fromJson(Map<String, dynamic> json) {
    return PopularFoodModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      categoryId: int.tryParse(json['category_id'].toString()) ?? 0,
      categories:
          (json['cuisines'] as List?)
              ?.map((e) => CategoryModel.fromJson(e))
              .toList() ??
          [],
      variations:
          (json['variations'] as List?)
              ?.map((e) => VariationModel.fromJson(e))
              .toList() ??
          [],
      addOns:
          (json['add_ons'] as List?)
              ?.map((e) => AddOnModel.fromJson(e))
              .toList() ??
          [],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      tax: double.tryParse(json['tax'].toString()) ?? 0.0,
      taxType: json['tax_type']?.toString() ?? '',
      discount: double.tryParse(json['discount'].toString()) ?? 0.0,
      discountType: json['discount_type']?.toString() ?? '',
      availableTimeStarts: json['available_time_starts']?.toString() ?? '',
      availableTimeEnds: json['available_time_ends']?.toString() ?? '',
      veg: int.tryParse(json['veg'].toString()) ?? 0,
      status: int.tryParse(json['status'].toString()) ?? 0,
      restaurantId: int.tryParse(json['restaurant_id'].toString()) ?? 0,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      orderCount: int.tryParse(json['order_count'].toString()) ?? 0,
      avgRating: double.tryParse(json['avg_rating'].toString()) ?? 0.0,
      ratingCount: int.tryParse(json['rating_count'].toString()) ?? 0,
      recommended: int.tryParse(json['recommended'].toString()) ?? 0,
      slug: json['slug']?.toString() ?? '',
      maximumCartQuantity: json['maximum_cart_quantity'],
      isHalal: int.tryParse(json['is_halal'].toString()) ?? 0,
      itemStock: int.tryParse(json['item_stock'].toString()) ?? 0,
      sellCount: int.tryParse(json['sell_count'].toString()) ?? 0,
      stockType: json['stock_type']?.toString() ?? '',
      tempAvailable: int.tryParse(json['temp_available'].toString()) ?? 0,
      open: int.tryParse(json['open'].toString()) ?? 0,
      reviewsCount: int.tryParse(json['reviews_count'].toString()) ?? 0,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      restaurantName: json['restaurant_name']?.toString() ?? '',
      restaurantStatus: int.tryParse(json['restaurant_status'].toString()) ?? 0,
      restaurantDiscount:
          double.tryParse(json['restaurant_discount'].toString()) ?? 0.0,
      restaurantOpeningTime: json['restaurant_opening_time'],
      restaurantClosingTime: json['restaurant_closing_time'],
      scheduleOrder:
          json['schedule_order'] == true || json['schedule_order'] == 1,
      minDeliveryTime: int.tryParse(json['min_delivery_time'].toString()) ?? 0,
      maxDeliveryTime: int.tryParse(json['max_delivery_time'].toString()) ?? 0,
      freeDelivery: int.tryParse(json['free_delivery'].toString()) ?? 0,
      halalTagStatus: int.tryParse(json['halal_tag_status'].toString()) ?? 0,
      nutritionsName:
          (json['nutritions_name'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      allergiesName:
          (json['allergies_name'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      cuisines:
          (json['cuisines'] as List?)
              ?.map((e) => CategoryModel.fromJson(e))
              .toList() ??
          [],
      imageFullUrl: json['image_full_url']?.toString() ?? '',
    );
  }
}

class CategoryModel {
  final int id;
  final String name;
  final String image;

  CategoryModel({required this.id, required this.name, required this.image});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}

class VariationModel {
  final int variationId;
  final String name;
  final String type;
  final String min;
  final String max;
  final String required;
  final List<VariationValueModel> values;

  VariationModel({
    required this.variationId,
    required this.name,
    required this.type,
    required this.min,
    required this.max,
    required this.required,
    required this.values,
  });

  factory VariationModel.fromJson(Map<String, dynamic> json) {
    return VariationModel(
      variationId: int.tryParse(json['variation_id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      min: json['min']?.toString() ?? '',
      max: json['max']?.toString() ?? '',
      required: json['required']?.toString() ?? '',
      values:
          (json['values'] as List?)
              ?.map((e) => VariationValueModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class VariationValueModel {
  final String label;
  final double optionPrice;
  final String totalStock;
  final String stockType;
  final String sellCount;
  final int optionId;
  final int currentStock;

  VariationValueModel({
    required this.label,
    required this.optionPrice,
    required this.totalStock,
    required this.stockType,
    required this.sellCount,
    required this.optionId,
    required this.currentStock,
  });

  factory VariationValueModel.fromJson(Map<String, dynamic> json) {
    return VariationValueModel(
      label: json['label']?.toString() ?? '',
      optionPrice: double.tryParse(json['optionPrice'].toString()) ?? 0.0,
      totalStock: json['total_stock']?.toString() ?? '',
      stockType: json['stock_type']?.toString() ?? '',
      sellCount: json['sell_count']?.toString() ?? '',
      optionId: int.tryParse(json['option_id'].toString()) ?? 0,
      currentStock: int.tryParse(json['current_stock'].toString()) ?? 0,
    );
  }
}

class AddOnModel {
  final int id;
  final String name;
  final double price;
  final String createdAt;
  final String updatedAt;
  final int restaurantId;
  final int status;
  final String stockType;
  final int addonStock;
  final int sellCount;

  AddOnModel({
    required this.id,
    required this.name,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.restaurantId,
    required this.status,
    required this.stockType,
    required this.addonStock,
    required this.sellCount,
  });

  factory AddOnModel.fromJson(Map<String, dynamic> json) {
    return AddOnModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      restaurantId: int.tryParse(json['restaurant_id'].toString()) ?? 0,
      status: int.tryParse(json['status'].toString()) ?? 0,
      stockType: json['stock_type']?.toString() ?? '',
      addonStock: int.tryParse(json['addon_stock'].toString()) ?? 0,
      sellCount: int.tryParse(json['sell_count'].toString()) ?? 0,
    );
  }
}
