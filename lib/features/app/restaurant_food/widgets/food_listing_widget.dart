import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helper/network_info.dart';
import '../controller/restaurant_controller.dart';
import '../domain/models/restaurant_model.dart';

class FoodListingWidget extends StatefulWidget {
  const FoodListingWidget({super.key});

  @override
  State<FoodListingWidget> createState() => _FoodListingWidgetState();
}

class _FoodListingWidgetState extends State<FoodListingWidget> {
  bool _wasDisconnected = false;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final internetProvider = context.read<InternetProvider>();
      final restaurantController = context.read<RestaurantController>();

      if (internetProvider.hasConnection) {
        restaurantController.refreshData();
        _wasDisconnected = false;
      } else {
        _wasDisconnected = true;
      }
      _hasInitialized = true;
    });
  }

  void _handleConnectivityChange(
    InternetProvider internetProvider,
    RestaurantController restaurantController,
  ) {
    if (!_hasInitialized) return;

    if (internetProvider.hasConnection && _wasDisconnected) {
      _wasDisconnected = false;

      Future.microtask(() {
        restaurantController.refreshData();
      });
    } else if (!internetProvider.hasConnection && !_wasDisconnected) {
      _wasDisconnected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Consumer2<RestaurantController, InternetProvider>(
        builder: (context, controller, internetProvider, child) {
          _handleConnectivityChange(internetProvider, controller);

          if (!internetProvider.hasConnection) {
            return _buildShimmerLoading();
          }

          if (controller.isLoading) {
            return _buildShimmerLoading();
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${controller.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: internetProvider.hasConnection
                        ? () => controller.refreshData()
                        : null,
                    child: const Text('Retry'),
                  ),
                  if (!internetProvider.hasConnection)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Please check your internet connection',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                ],
              ),
            );
          }

          final foodsFromSortedRestaurants = controller
              .getFoodsFromSortedRestaurants();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Restaurants',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    if (internetProvider.hasConnection)
                      Material(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.selectedSortOption,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: controller.sortOptions.map((
                                String option,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(
                                    option,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.setSortOption(newValue);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              if (foodsFromSortedRestaurants.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No food items found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: foodsFromSortedRestaurants.length,
                  itemBuilder: (context, index) {
                    final food = foodsFromSortedRestaurants[index];
                    final restaurant = controller.getRestaurantForFood(food);
                    return _buildFoodCard(food, restaurant, index);
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 28,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 20,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        ...List.generate(6, (index) => _buildShimmerCard(index)),
      ],
    );
  }

  Widget _buildShimmerCard(int index) {
    return Container(
      margin: EdgeInsets.only(
        left: 0,
        right: 0,
        top: index == 0 ? 4 : 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 16,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodCard(Food food, Restaurant? restaurant, int index) {
    final random = Random();
    final int randomPrice = 5 + random.nextInt(21);

    return Container(
      margin: EdgeInsets.only(
        left: 0,
        right: 0,
        top: index == 0 ? 4 : 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: food.imageFullUrl.isNotEmpty
                    ? Image.network(
                        food.imageFullUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.fastfood,
                            color: Colors.grey,
                            size: 40,
                          );
                        },
                      )
                    : const Icon(Icons.fastfood, color: Colors.grey, size: 40),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (restaurant != null)
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 4),

                  if (restaurant != null)
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          final rating = restaurant.avgRating;
                          final isFullStar = index < rating.floor();
                          final isHalfStar =
                              index < rating && index >= rating.floor();

                          return Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: Icon(
                              isFullStar
                                  ? Icons.star
                                  : isHalfStar
                                  ? Icons.star_half
                                  : Icons.star_border,
                              color: Colors.green,
                              size: 16,
                            ),
                          );
                        }),
                      ],
                    ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Text(
                        '\$${randomPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Column(
              children: [
                // Heart Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.black, size: 26),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
