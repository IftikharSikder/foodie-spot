import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/base_widgets/custom_snackbar_widgets.dart';
import '../controller/category_controller.dart';
import '../domain/models/category_model.dart';
import '../screen/category_view_all_screen.dart';

class HorizontalCategoryWidget extends StatefulWidget {
  final VoidCallback? onViewAllTap;
  final Function(CategoryModel)? onCategorySelected;
  final bool showAllOption;

  const HorizontalCategoryWidget({
    Key? key,
    this.onViewAllTap,
    this.onCategorySelected,
    this.showAllOption = true,
  }) : super(key: key);

  @override
  State<HorizontalCategoryWidget> createState() =>
      _HorizontalCategoryWidgetState();
}

class _HorizontalCategoryWidgetState extends State<HorizontalCategoryWidget> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

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
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          widget.onViewAllTap ??
                          () => _navigateToViewAll(context),
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(height: 90, child: _buildContent(context, controller)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, CategoryController controller) {
    if (controller.isLoading) {
      return _buildLoadingState();
    }
    if (controller.error.isNotEmpty) {
      _hasError = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        customSnackBar(controller.error, context, isError: true);
      });
      return _buildLoadingState();
    } else {
      _hasError = false;
    }
    if (controller.parentCategories.isEmpty) {
      return _buildEmptyState();
    }
    return _buildCategoryList(context, controller);
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          width: 70,
          margin: const EdgeInsets.only(right: 16),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, color: Colors.grey[400], size: 32),
          const SizedBox(height: 8),
          Text(
            'No categories available',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(
    BuildContext context,
    CategoryController controller,
  ) {
    final categories = controller.parentCategories;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: widget.showAllOption
          ? categories.length + 1
          : categories.length,
      itemBuilder: (context, index) {
        if (widget.showAllOption && index == 0) {
          return _buildCategoryItem(
            context: context,
            title: 'All',
            icon: Icons.apps,
            isSelected: controller.selectedCategory == null,
            onTap: () {
              controller.clearSelection();
              widget.onCategorySelected?.call(
                CategoryModel(
                  id: -1,
                  name: 'All',
                  image: '',
                  parentId: 0,
                  position: 0,
                  status: 1,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  priority: 0,
                  slug: 'all',
                  productsCount: 0,
                  childesCount: 0,
                  orderCount: '0',
                  translations: [],
                  storage: [],
                  childes: [],
                ),
              );
            },
          );
        }

        final categoryIndex = widget.showAllOption ? index - 1 : index;
        final category = categories[categoryIndex];

        return _buildCategoryItem(
          context: context,
          title: category.name,
          imageUrl: category.imageFullUrl,
          icon: _getCategoryIcon(category.name),
          isSelected: controller.selectedCategory?.id == category.id,
          onTap: () {
            controller.selectCategory(category);
            widget.onCategorySelected?.call(category);
          },
        );
      },
    );
  }

  Widget _buildCategoryItem({
    required BuildContext context,
    required String title,
    String? imageUrl,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 2,
                ),
              ),
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            customSnackBar(
                              'Failed to load category image',
                              context,
                              isError: true,
                            );
                          });

                          return Icon(
                            icon ?? Icons.category,
                            color: isSelected ? Colors.white : Colors.grey[600],
                            size: 28,
                          );
                        },
                      ),
                    )
                  : Icon(
                      icon ?? Icons.category,
                      color: isSelected ? Colors.white : Colors.grey[600],
                      size: 28,
                    ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.blue : Colors.grey[700],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();

    if (name.contains('coffee')) return Icons.coffee;
    if (name.contains('drink') || name.contains('beverage'))
      return Icons.local_drink;
    if (name.contains('fast') || name.contains('burger')) return Icons.fastfood;
    if (name.contains('cake') || name.contains('dessert')) return Icons.cake;
    if (name.contains('sushi') || name.contains('fish')) return Icons.set_meal;
    if (name.contains('pizza')) return Icons.local_pizza;
    if (name.contains('ice') || name.contains('cream')) return Icons.icecream;
    if (name.contains('salad')) return Icons.eco;
    if (name.contains('meat')) return Icons.restaurant;
    if (name.contains('bread') || name.contains('bakery'))
      return Icons.bakery_dining;

    return Icons.restaurant_menu;
  }

  void _navigateToViewAll(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CategoryViewAllScreen()),
    );
  }
}
