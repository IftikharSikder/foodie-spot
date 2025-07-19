import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/app/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../common/base_widgets/custom_snackbar_widgets.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_dimensions.dart';
import '../../../../constants/app_strings.dart';
import '../controller/category_controller.dart';
import '../domain/models/category_model.dart';

class HorizontalCategoryWidget extends StatefulWidget {
  final VoidCallback? onViewAllTap;
  final Function(CategoryModel)? onCategorySelected;
  final bool showAllOption;

  const HorizontalCategoryWidget({
    super.key,
    this.onViewAllTap,
    this.onCategorySelected,
    this.showAllOption = true,
  });

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
          padding: EdgeInsets.only(
            top: AppDimensions.spacingSmall,
            bottom: AppDimensions.spacingSmall,
            left: AppDimensions.addressPaddingHorizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.categoriesLabel,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTitleMedium,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: AppDimensions.addressPaddingHorizontal,
                    ),
                    child: GestureDetector(
                      onTap:
                          widget.onViewAllTap ??
                          () => _navigateToViewAll(context),
                      child: Text(
                        AppStrings.viewAllLabel,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navigationActive,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.navigationActive,
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppDimensions.addressPaddingTop),

              SizedBox(
                height: AppDimensions.categoryItemHeight,
                child: _buildContent(context, controller),
              ),
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
        customSnackBar(AppStrings.failedToLoadData, context, isError: true);
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
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          width: AppDimensions.categoryItemWidth,
          margin: EdgeInsets.only(
            right: AppDimensions.addressPaddingHorizontal,
          ),
          child: Column(
            children: [
              Container(
                width: AppDimensions.categoryIconSize,
                height: AppDimensions.categoryIconSize,
                decoration: BoxDecoration(
                  color: AppColors.bannerPlaceholderBackground,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.restaurantCardRadius,
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.spacingSmall),
              Container(
                width: 40.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: AppColors.bannerPlaceholderBackground,
                  borderRadius: BorderRadius.circular(6.r),
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
          Icon(
            Icons.category_outlined,
            color: AppColors.iconGrey,
            size: AppDimensions.emptyStateIconSize,
          ),
          SizedBox(height: AppDimensions.spacingSmall),
          Text(
            AppStrings.noCategoriesAvailable,
            style: TextStyle(
              fontSize: AppDimensions.searchFontSize,
              color: AppColors.textGrey,
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
      itemCount: widget.showAllOption
          ? categories.length + 1
          : categories.length,
      itemBuilder: (context, index) {
        if (widget.showAllOption && index == 0) {
          return _buildCategoryItem(
            context: context,
            title: AppStrings.allLabel,
            icon: Icons.apps,
            isSelected: controller.selectedCategory == null,
            onTap: () {
              controller.clearSelection();
              widget.onCategorySelected?.call(
                CategoryModel(
                  id: -1,
                  name: AppStrings.allLabel,
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
    return Container(
      width: AppDimensions.categoryItemWidth,
      margin: EdgeInsets.only(right: AppDimensions.addressPaddingHorizontal),
      child: Column(
        children: [
          Material(
            elevation: isSelected ? AppDimensions.shadowBlurRadius : 4.0,
            borderRadius: BorderRadius.circular(
              AppDimensions.restaurantCardRadius,
            ),
            shadowColor: AppColors.shadowColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(
                AppDimensions.restaurantCardRadius,
              ),
              onTap: onTap,
              child: Container(
                width: AppDimensions.categoryIconSize,
                height: AppDimensions.categoryIconSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.restaurantCardRadius,
                  ),
                  border: Border.all(
                    color: isSelected ? AppColors.sPrimary : Colors.transparent,
                    width: 2.w,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Container(
                          width: AppDimensions.categoryIconSize,
                          height: AppDimensions.categoryIconSize,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          width: AppDimensions.categoryIconSize,
                          height: AppDimensions.categoryIconSize,
                          color: isSelected
                              ? AppColors.sPrimary
                              : AppColors.bannerPlaceholderBackground,
                          child: Icon(
                            icon ?? Icons.category,
                            color: isSelected
                                ? AppColors.background
                                : AppColors.iconGrey,
                            size: AppDimensions.homeIconSize,
                          ),
                        ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacingSmall),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: AppDimensions.searchFontSize,
              fontWeight: FontWeight.w500,
              color: AppColors.title,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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

  void _navigateToViewAll(BuildContext context) {
    context.goNamed(Screens.categoryViewAllScreen.name);
  }
}
