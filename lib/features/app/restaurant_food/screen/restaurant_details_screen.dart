import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_routes.dart';
import '../controller/restaurant_controller.dart';
import '../domain/models/restaurant_model.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final Restaurant restaurant;
  final Food? selectedFood;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurant,
    this.selectedFood,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: restaurant.coverPhotoFullUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(restaurant.coverPhotoFullUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: restaurant.coverPhotoFullUrl.isEmpty
                    ? Colors.grey[300]
                    : null,
              ),
              child: restaurant.coverPhotoFullUrl.isEmpty
                  ? const Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 80,
                        color: Colors.grey,
                      ),
                    )
                  : null,
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: restaurant.logoFullUrl.isNotEmpty
                            ? Image.network(
                                restaurant.logoFullUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.restaurant),
                                  );
                                },
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.restaurant),
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              restaurant.address,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber[700],
                                  size: 20,
                                ),
                                Text(
                                  '${restaurant.avgRating.toStringAsFixed(1)} (${restaurant.ratingCount} reviews)',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem(
                        icon: Icons.access_time,
                        label: 'Delivery Time',
                        value: restaurant.deliveryTime,
                      ),
                      _buildInfoItem(
                        icon: Icons.delivery_dining,
                        label: 'Delivery Fee',
                        value: restaurant.deliveryFee,
                      ),
                      _buildInfoItem(
                        icon: Icons.schedule,
                        label: 'Status',
                        value: restaurant.open ? 'Open' : 'Closed',
                        color: restaurant.open ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  if (selectedFood != null) ...[
                    Card(
                      color: Colors.blue[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Selected Item',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: selectedFood!.imageFullUrl.isNotEmpty
                                      ? Image.network(
                                          selectedFood!.imageFullUrl,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  width: 80,
                                                  height: 80,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.fastfood,
                                                  ),
                                                );
                                              },
                                        )
                                      : Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.fastfood),
                                        ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedFood!.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        selectedFood!.description,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  const Text(
                    'Menu',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  if (restaurant.foods.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'No foods available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Consumer<RestaurantController>(
                      builder: (context, controller, child) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: restaurant.foods.length,
                          itemBuilder: (context, index) {
                            final food = restaurant.foods[index];
                            final isSelected = selectedFood?.id == food.id;

                            return Card(
                              color: isSelected ? Colors.blue[50] : null,
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: food.imageFullUrl.isNotEmpty
                                      ? Image.network(
                                          food.imageFullUrl,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.fastfood,
                                                  ),
                                                );
                                              },
                                        )
                                      : Container(
                                          width: 50,
                                          height: 50,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.fastfood),
                                        ),
                                ),
                                title: Text(
                                  food.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  food.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.blue,
                                      )
                                    : null,
                                onTap: () {
                                  context.pushReplacementNamed(
                                    Screens.restaurantDetails.name,
                                    extra: {
                                      'restaurant': restaurant,
                                      'selectedFood': food,
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.grey[600]),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
