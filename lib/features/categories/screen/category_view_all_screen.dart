import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/base_widgets/custom_snackbar_widgets.dart';
import '../controller/category_controller.dart';
import '../domain/models/category_model.dart';
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'All Categories',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<CategoryController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const _LoadingView();
          }

          if (controller.error.isNotEmpty) {
            _hasError = true;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              customSnackBar(controller.error, context, isError: true);
            });

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
            color: Colors.blue,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Browse Categories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${controller.parentCategories.length} categories available',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (controller.parentCategories.isNotEmpty) ...[
                    _buildSectionHeader('Main Categories'),
                    _buildParentCategoriesGrid(controller),
                  ],

                  _buildSectionHeader('All Categories'),
                  _buildAllCategoriesList(controller),

                  if (controller.selectedCategory != null) ...[
                    _buildSectionHeader(
                      '${controller.selectedCategory!.name} Products',
                      trailing: TextButton(
                        onPressed: controller.clearSelection,
                        child: const Text('Clear'),
                      ),
                    ),
                    _buildSelectedCategoryProducts(controller),
                  ],

                  const SizedBox(height: 20),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildParentCategoriesGrid(CategoryController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: controller.parentCategories.length,
        itemBuilder: (context, index) {
          final category = controller.parentCategories[index];
          return CategoryProductItemWidget(
            product: category,
            onTap: () {
              controller.selectCategory(category);
              _showSubcategoriesBottomSheet(context, category, controller);
            },
          );
        },
      ),
    );
  }

  Widget _buildAllCategoriesList(CategoryController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          return CategoryItemWidget(
            category: category,
            isSelected: controller.selectedCategory?.id == category.id,
            onTap: () {
              controller.selectCategory(category);
              if (category.childesCount > 0) {
                _showSubcategoriesBottomSheet(context, category, controller);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildSelectedCategoryProducts(CategoryController controller) {
    if (controller.isProductsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: CategoryProductShimmerWidget(),
      );
    }

    if (controller.categoryProducts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: controller.categoryProducts.length,
        itemBuilder: (context, index) {
          final product = controller.categoryProducts[index];
          return CategoryProductItemWidget(
            product: product,
            onTap: () {
              _handleProductTap(product);
            },
          );
        },
      ),
    );
  }

  void _showSubcategoriesBottomSheet(
    BuildContext context,
    CategoryModel category,
    CategoryController controller,
  ) {
    final subcategories = controller.getSubCategories(category.id);

    if (subcategories.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${category.name} Subcategories',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Subcategories list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: subcategories.length,
                  itemBuilder: (context, index) {
                    final subcategory = subcategories[index];
                    return CategoryItemWidget(
                      category: subcategory,
                      isSelected:
                          controller.selectedCategory?.id == subcategory.id,
                      onTap: () {
                        controller.selectCategory(subcategory);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleProductTap(CategoryModel product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected: ${product.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 80),
          CategoryShimmerWidget(itemCount: 8),
          SizedBox(height: 20),
          CategoryProductShimmerWidget(),
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Categories Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Categories will appear here when available',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
