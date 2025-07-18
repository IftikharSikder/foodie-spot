// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../controller/restaurant_controller.dart';
// import '../domain/models/restaurant_model.dart';
//
// class FoodListingWidget extends StatelessWidget {
//   const FoodListingWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<RestaurantController>(
//       builder: (context, controller, child) {
//         if (controller.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (controller.errorMessage.isNotEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Error: ${controller.errorMessage}',
//                   style: const TextStyle(color: Colors.red),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () => controller.refreshData(),
//                   child: const Text('Retry'),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         final foodsFromSortedRestaurants = controller
//             .getFoodsFromSortedRestaurants();
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Restaurants',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   // Sort Dropdown
//                   Material(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         //border: Border.all(color: Colors.grey.shade300),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           value: controller.selectedSortOption,
//                           icon: const Icon(Icons.keyboard_arrow_down),
//                           items: controller.sortOptions.map((String option) {
//                             return DropdownMenuItem<String>(
//                               value: option,
//                               child: Text(
//                                 option,
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (String? newValue) {
//                             if (newValue != null) {
//                               controller.setSortOption(newValue);
//                             }
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             if (foodsFromSortedRestaurants.isEmpty)
//               const Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(32),
//                   child: Text(
//                     'No food items found',
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                 ),
//               )
//             else
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: foodsFromSortedRestaurants.length,
//                 itemBuilder: (context, index) {
//                   final food = foodsFromSortedRestaurants[index];
//                   final restaurant = controller.getRestaurantForFood(food);
//                   return _buildFoodCard(food, restaurant);
//                 },
//               ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildFoodCard(Food food, Restaurant? restaurant) {
//     final random = Random();
//     final int randomPrice = 5 + random.nextInt(21);
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             // Food Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade200,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: food.imageFullUrl.isNotEmpty
//                     ? Image.network(
//                         food.imageFullUrl,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return const Icon(
//                             Icons.fastfood,
//                             color: Colors.grey,
//                             size: 40,
//                           );
//                         },
//                       )
//                     : const Icon(Icons.fastfood, color: Colors.grey, size: 40),
//               ),
//             ),
//
//             const SizedBox(width: 12),
//
//             // Food Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Food Name
//                   Text(
//                     food.name,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   if (restaurant != null)
//                     Text(
//                       restaurant.name,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.blue[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//
//                   const SizedBox(height: 4),
//
//                   if (restaurant != null)
//                     Row(
//                       children: [
//                         ...List.generate(5, (index) {
//                           final rating = restaurant.avgRating;
//                           final isFullStar = index < rating.floor();
//                           final isHalfStar =
//                               index < rating && index >= rating.floor();
//
//                           return Padding(
//                             padding: const EdgeInsets.only(right: 2),
//                             child: Icon(
//                               isFullStar
//                                   ? Icons.star
//                                   : isHalfStar
//                                   ? Icons.star_half
//                                   : Icons.star_border,
//                               color: (isFullStar || isHalfStar)
//                                   ? Colors.amber
//                                   : Colors.grey.shade300,
//                               size: 16,
//                             ),
//                           );
//                         }),
//                       ],
//                     ),
//
//                   const SizedBox(height: 4),
//
//                   // Price
//                   Row(
//                     children: [
//                       Text(
//                         '\$${randomPrice.toStringAsFixed(2)}',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             Column(
//               children: [
//                 // Heart Icon
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Icon(
//                     Icons.favorite_border,
//                     color: Colors.grey,
//                     size: 20,
//                   ),
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 // Add to Cart Icon
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Icon(Icons.add, color: Colors.green, size: 26),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/restaurant_controller.dart';
import '../domain/models/restaurant_model.dart';

class FoodListingWidget extends StatelessWidget {
  const FoodListingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
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
                  onPressed: () => controller.refreshData(),
                  child: const Text('Retry'),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ), // Changed from 16 to 0
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
                  // Sort Dropdown
                  Material(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        //border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedSortOption,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: controller.sortOptions.map((String option) {
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
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: foodsFromSortedRestaurants.length,
                itemBuilder: (context, index) {
                  final food = foodsFromSortedRestaurants[index];
                  final restaurant = controller.getRestaurantForFood(food);
                  return _buildFoodCard(food, restaurant);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildFoodCard(Food food, Restaurant? restaurant) {
    final random = Random();
    final int randomPrice = 5 + random.nextInt(21);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 8,
      ), // Changed from 16 to 0
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
            // Food Image
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

            // Food Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food Name
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
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w500,
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
                              color: (isFullStar || isHalfStar)
                                  ? Colors.amber
                                  : Colors.grey.shade300,
                              size: 16,
                            ),
                          );
                        }),
                      ],
                    ),

                  const SizedBox(height: 4),

                  // Price
                  Row(
                    children: [
                      Text(
                        '\$${randomPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
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

                // Add to Cart Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.green, size: 26),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
