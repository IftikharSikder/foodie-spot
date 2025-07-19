import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/app/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_dimensions.dart';
import '../../../../constants/app_strings.dart';
import '../controller/category_controller.dart';
import '../widgets/category_item_widget.dart';
import '../widgets/category_shimmer_widget.dart';

class CategoryViewAllScreen extends StatefulWidget {
  const CategoryViewAllScreen({super.key});

  @override
  State<CategoryViewAllScreen> createState() => _CategoryViewAllScreenState();
}

class _CategoryViewAllScreenState extends State<CategoryViewAllScreen> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _hasError = false;

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
    return Scaffold(
      backgroundColor: AppColors.sBackground,
      appBar: AppBar(
        title: Text(
          AppStrings.allCategoriesTitle,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textTitleMedium,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColors.textTitleMedium,
          size: AppDimensions.homeIconSize,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.goNamed(Screens.dashboard.name),
        ),
      ),
      body: Consumer<CategoryController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const _LoadingView();
          }

          if (controller.error.isNotEmpty) {
            _hasError = true;
            return const _LoadingView();
          } else {
            _hasError = false;
          }

          if (controller.categories.isEmpty) {
            return const _EmptyView();
          }

          return RefreshIndicator(
            onRefresh: () async {
              controller.refresh();
            },
            color: AppColors.sPrimary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  if (controller.parentCategories.isNotEmpty) ...[
                    _buildSectionHeader(AppStrings.mainCategoriesLabel),
                  ],
                  _buildAllCategoriesList(controller),
                  if (controller.selectedCategory != null) ...[
                    _buildSectionHeader(
                      '${controller.selectedCategory!.name} ${AppStrings.productsLabel}',
                      trailing: TextButton(
                        onPressed: controller.clearSelection,
                        child: Text(
                          AppStrings.clearLabel,
                          style: TextStyle(
                            color: AppColors.sPrimary,
                            fontSize: AppDimensions.searchFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    _buildSelectedCategoryProducts(controller),
                  ],

                  SizedBox(height: AppDimensions.spacingLarge),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Widget? trailing}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.addressPaddingHorizontal,
        vertical: AppDimensions.sectionHeaderPaddingVertical,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [if (trailing != null) trailing],
      ),
    );
  }

  Widget _buildAllCategoriesList(CategoryController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingSmall),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          return CategoryItemWidget(
            category: category,
            isSelected: controller.selectedCategory?.id == category.id,
            onTap: () {},
          );
        },
      ),
    );
  }

  Widget _buildSelectedCategoryProducts(CategoryController controller) {
    if (controller.isProductsLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.addressPaddingHorizontal,
        ),
        child: const CategoryProductShimmerWidget(),
      );
    }

    if (controller.categoryProducts.isEmpty) {
      return Container(
        padding: EdgeInsets.all(AppDimensions.emptyStatePadding),
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: AppDimensions.emptyStateIconSize,
              color: AppColors.iconGrey,
            ),
            SizedBox(height: AppDimensions.addressPaddingTop),
            Text(
              AppStrings.noProductsFound,
              style: TextStyle(
                fontSize: AppDimensions.subtitleFont,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.addressPaddingHorizontal,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: AppDimensions.productGridAspectRatio,
          crossAxisSpacing: AppDimensions.categoryGridSpacing,
          mainAxisSpacing: AppDimensions.categoryGridSpacing,
        ),
        itemCount: controller.categoryProducts.length,
        itemBuilder: (context, index) {
          final product = controller.categoryProducts[index];
          return CategoryProductItemWidget(product: product, onTap: () {});
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: AppDimensions.loadingStateTopSpacing),
          const CategoryShimmerWidget(itemCount: 8),
          SizedBox(height: AppDimensions.spacingLarge),
          const CategoryProductShimmerWidget(),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.emptyStatePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: AppDimensions.emptyStateIconSize,
              color: AppColors.iconGrey,
            ),
            SizedBox(height: AppDimensions.addressPaddingTop),
            Text(
              AppStrings.noCategoriesAvailable,
              style: TextStyle(
                fontSize: AppDimensions.emptyStateTitleSize,
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey,
              ),
            ),
            SizedBox(height: AppDimensions.spacingSmall),
            Text(
              AppStrings.categoriesWillAppearHere,
              style: TextStyle(
                fontSize: AppDimensions.searchFontSize,
                color: AppColors.iconGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
