import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/restaurant_controller.dart';
import 'restaurant_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<RestaurantController>(
        context,
        listen: false,
      );
      controller.initializeData();
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantController>(
      builder: (context, controller, child) {
        final restaurantsToShow = controller.searchQuery.isEmpty
            ? controller.restaurants
            : controller.filteredRestaurants;

        final foodsToShow = controller.searchQuery.isEmpty
            ? controller.restaurants.expand((r) => r.foods).toList()
            : controller.filteredFoods;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Search'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                controller.clearSearch();
                Navigator.pop(context);
              },
            ),
          ),
          body: Column(
            children: [
              // Search TextField
              Container(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    onChanged: (value) {
                      controller.searchRestaurantsAndFoods(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search restaurants or foods...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: controller.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                controller.clearSearch();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),

              // Search Results
              Expanded(
                child: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        children: [
                          if (restaurantsToShow.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                controller.searchQuery.isEmpty
                                    ? 'All Restaurants'
                                    : 'Restaurants',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...restaurantsToShow.map(
                              (restaurant) => Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: restaurant.logoFullUrl.isNotEmpty
                                        ? Image.network(
                                            restaurant.logoFullUrl,
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
                                                      Icons.restaurant,
                                                    ),
                                                  );
                                                },
                                          )
                                        : Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.restaurant),
                                          ),
                                  ),
                                  title: Text(
                                    restaurant.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        restaurant.address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber[700],
                                            size: 16,
                                          ),
                                          Text(
                                            restaurant.avgRating
                                                .toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${restaurant.deliveryTime} • ${restaurant.deliveryFee}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        restaurant.open
                                            ? Icons.schedule
                                            : Icons.close,
                                        color: restaurant.open
                                            ? Colors.green
                                            : Colors.red,
                                        size: 16,
                                      ),
                                      Text(
                                        restaurant.open ? 'Open' : 'Closed',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: restaurant.open
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RestaurantDetailsScreen(
                                              restaurant: restaurant,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Food Results
                          if (foodsToShow.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                controller.searchQuery.isEmpty
                                    ? 'All Foods'
                                    : 'Foods',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...foodsToShow.map(
                              (food) => Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
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
                                  onTap: () {
                                    final restaurant = controller.restaurants
                                        .firstWhere(
                                          (r) => r.foods.any(
                                            (f) => f.id == food.id,
                                          ),
                                        );

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RestaurantDetailsScreen(
                                              restaurant: restaurant,
                                              selectedFood: food,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],

                          if (restaurantsToShow.isEmpty &&
                              foodsToShow.isEmpty &&
                              controller.searchQuery.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.all(32),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No results found',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Try different keywords',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
