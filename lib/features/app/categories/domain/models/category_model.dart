class CategoryModel {
  final int id;
  final String name;
  final String image;
  final int parentId;
  final int position;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int priority;
  final String slug;
  final int productsCount;
  final int childesCount;
  final String orderCount;
  final String? imageFullUrl;
  final List<Translation> translations;
  final List<Storage> storage;
  final List<CategoryModel> childes;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.parentId,
    required this.position,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.priority,
    required this.slug,
    required this.productsCount,
    required this.childesCount,
    required this.orderCount,
    this.imageFullUrl,
    required this.translations,
    required this.storage,
    required this.childes,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      parentId: json['parent_id'] ?? 0,
      position: json['position'] ?? 0,
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      priority: json['priority'] ?? 0,
      slug: json['slug'] ?? '',
      productsCount: json['products_count'] ?? 0,
      childesCount: json['childes_count'] ?? 0,
      orderCount: json['order_count']?.toString() ?? '0',
      imageFullUrl: json['image_full_url'],
      translations:
          (json['translations'] as List<dynamic>?)
              ?.map((e) => Translation.fromJson(e))
              .toList() ??
          [],
      storage:
          (json['storage'] as List<dynamic>?)
              ?.map((e) => Storage.fromJson(e))
              .toList() ??
          [],
      childes:
          (json['childes'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'parent_id': parentId,
      'position': position,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'priority': priority,
      'slug': slug,
      'products_count': productsCount,
      'childes_count': childesCount,
      'order_count': orderCount,
      'image_full_url': imageFullUrl,
      'translations': translations.map((e) => e.toJson()).toList(),
      'storage': storage.map((e) => e.toJson()).toList(),
      'childes': childes.map((e) => e.toJson()).toList(),
    };
  }
}

class Translation {
  final int id;
  final String translationableType;
  final int translationableId;
  final String locale;
  final String key;
  final String value;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Translation({
    required this.id,
    required this.translationableType,
    required this.translationableId,
    required this.locale,
    required this.key,
    required this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json['id'] ?? 0,
      translationableType: json['translationable_type'] ?? '',
      translationableId: json['translationable_id'] ?? 0,
      locale: json['locale'] ?? '',
      key: json['key'] ?? '',
      value: json['value'] ?? '',
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
      'translationable_type': translationableType,
      'translationable_id': translationableId,
      'locale': locale,
      'key': key,
      'value': value,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Storage {
  final int id;
  final String dataType;
  final String dataId;
  final String key;
  final String value;
  final DateTime createdAt;
  final DateTime updatedAt;

  Storage({
    required this.id,
    required this.dataType,
    required this.dataId,
    required this.key,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Storage.fromJson(Map<String, dynamic> json) {
    return Storage(
      id: json['id'] ?? 0,
      dataType: json['data_type'] ?? '',
      dataId: json['data_id']?.toString() ?? '',
      key: json['key'] ?? '',
      value: json['value'] ?? '',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data_type': dataType,
      'data_id': dataId,
      'key': key,
      'value': value,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
