import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../app/categories/controller/category_controller.dart';
import '../../../app/categories/domain/models/category_model.dart';

class WebCategoriesWidget extends StatefulWidget {
  final Function(CategoryModel)? onCategorySelected;
  final Function(CategoryModel)? onProductTap;
  final double maxWidth;
  final bool showProducts;

  const WebCategoriesWidget({
    super.key,
    this.onCategorySelected,
    this.onProductTap,
    this.maxWidth = 1200,
    this.showProducts = true,
  });

  @override
  State<WebCategoriesWidget> createState() => _WebCategoriesWidgetState();
}

class _WebCategoriesWidgetState extends State<WebCategoriesWidget> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _hasError = false;
  bool _showAllCategories = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<CategoryController>(
        context,
        listen: false,
      );
      if (controller.categories.isEmpty) {
        controller.fetchCategories();
      }
    });

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (results.any((result) => result != ConnectivityResult.none) &&
          _hasError) {
        _hasError = false;
        context.read<CategoryController>().fetchCategories();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, controller, child) {
        return Padding(
          padding: EdgeInsets.only(right: 16.0.w),
          child: Container(
            constraints: BoxConstraints(maxWidth: widget.maxWidth),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(controller),
                const SizedBox(height: 20),
                if (controller.isLoading) ...[
                  _buildLoadingState(),
                ] else if (controller.error.isNotEmpty)
                  ...[]
                else if (controller.categories.isEmpty)
                  ...[]
                else ...[
                  if (!_showAllCategories) ...[
                    _buildHorizontalCategories(controller),
                  ] else ...[
                    _buildAllCategoriesGrid(controller),
                  ],
                ],
                if (widget.showProducts &&
                    controller.selectedCategory != null) ...[
                  const SizedBox(height: 40),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(CategoryController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0.w),
          child: Text(
            _showAllCategories ? 'All Categories' : 'Categories',
            style: GoogleFonts.poppins(
              fontSize: 37.r,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
        ),
        if (!_showAllCategories) ...[
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showAllCategories = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'View All',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ] else ...[
          TextButton.icon(
            onPressed: () {
              setState(() {
                _showAllCategories = false;
              });
            },
            icon: const Icon(
              Icons.view_carousel,
              size: 18,
              color: Color(0xFF4299E1),
            ),
            label: const Text(
              'Horizontal View',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4299E1),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHorizontalCategories(CategoryController controller) {
    final categories = controller.parentCategories;

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHorizontalCategoryItem(
              context: context,
              title: 'All',
              icon: Icons.apps,
              isSelected: controller.selectedCategory == null,
            );
          }

          final category = categories[index - 1];
          return _buildHorizontalCategoryItem(
            context: context,
            title: category.name,
            imageUrl: category.imageFullUrl,
            icon: _getCategoryIcon(category.name),
            isSelected: controller.selectedCategory?.id == category.id,
          );
        },
      ),
    );
  }

  Widget _buildHorizontalCategoryItem({
    required BuildContext context,
    required String title,
    String? imageUrl,
    IconData? icon,
    required bool isSelected,
  }) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Material(
            elevation: isSelected ? 8 : 4,
            borderRadius: BorderRadius.circular(16),
            shadowColor: Colors.black.withValues(alpha: 0.1),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF4299E1)
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFFF7FAFC),
                            child: Icon(
                              icon ?? Icons.category,
                              color: const Color(0xFFA0AEC0),
                              size: 32,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFFF7FAFC),
                            child: Icon(
                              icon ?? Icons.category,
                              color: const Color(0xFFA0AEC0),
                              size: 32,
                            ),
                          ),
                        )
                      : Container(
                          color: isSelected
                              ? const Color(0xFF4299E1)
                              : const Color(0xFFF7FAFC),
                          child: Icon(
                            icon ?? Icons.category,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFFA0AEC0),
                            size: 32,
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? const Color(0xFF4299E1)
                  : const Color(0xFF4A5568),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAllCategoriesGrid(CategoryController controller) {
    final categories = controller.categories;

    return Column(
      children: [
        if (controller.selectedCategory != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4299E1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4299E1).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: const Color(0xFF4299E1),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Selected: ${controller.selectedCategory!.name}',
                  style: const TextStyle(
                    color: Color(0xFF4299E1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: controller.clearSelection,
                  child: const Text(
                    'Clear Selection',
                    style: TextStyle(
                      color: Color(0xFF4299E1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 2;
            if (constraints.maxWidth > 1200) {
              crossAxisCount = 6;
            } else if (constraints.maxWidth > 900) {
              crossAxisCount = 5;
            } else if (constraints.maxWidth > 600) {
              crossAxisCount = 4;
            } else if (constraints.maxWidth > 400) {
              crossAxisCount = 3;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.9,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return _buildGridCategoryItem(
                  category: category,
                  controller: controller,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildGridCategoryItem({
    required CategoryModel category,
    required CategoryController controller,
  }) {
    final isSelected = controller.selectedCategory?.id == category.id;

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF4299E1)
                  : Colors.grey.withValues(alpha: 0.2),
              width: isSelected ? 3 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child:
                        category.imageFullUrl != null &&
                            category.imageFullUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: category.imageFullUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(color: Colors.white),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: Icon(
                                _getCategoryIcon(category.name),
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: Icon(
                              _getCategoryIcon(category.name),
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFF4299E1)
                              : const Color(0xFF2D3748),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            '${category.productsCount} items',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4299E1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 16),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 60,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();

    if (name.contains('coffee')) return Icons.coffee;
    if (name.contains('drink') || name.contains('beverage')) {
      return Icons.local_drink;
    }
    if (name.contains('fast') || name.contains('burger')) return Icons.fastfood;
    if (name.contains('cake') || name.contains('dessert')) return Icons.cake;
    if (name.contains('sushi') || name.contains('fish')) return Icons.set_meal;
    if (name.contains('pizza')) return Icons.local_pizza;
    if (name.contains('ice') || name.contains('cream')) return Icons.icecream;
    if (name.contains('salad')) return Icons.eco;
    if (name.contains('meat')) return Icons.restaurant;
    if (name.contains('bread') || name.contains('bakery')) {
      return Icons.bakery_dining;
    }

    return Icons.restaurant_menu;
  }
}
