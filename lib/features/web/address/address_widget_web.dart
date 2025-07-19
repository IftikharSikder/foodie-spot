import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../app/restaurant_food/controller/restaurant_controller.dart';
import '../../app/restaurant_food/domain/models/restaurant_model.dart';

class WebHeaderWidget extends StatefulWidget {
  const WebHeaderWidget({super.key});
  @override
  State<WebHeaderWidget> createState() => _WebHeaderWidgetState();
}

class _WebHeaderWidgetState extends State<WebHeaderWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;
  bool _isNotificationHovered = false;
  bool _isSearchResultsVisible = false;
  final FocusNode _searchFocusNode = FocusNode();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<RestaurantController>(
        context,
        listen: false,
      );
      controller.initializeData();
    });

    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
      if (!_searchFocusNode.hasFocus && _isSearchResultsVisible) {
        _hideSearchResults();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _hideSearchResults();
    super.dispose();
  }

  void _showSearchResults() {
    if (_overlayEntry != null) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx + 24 + (size.width * 3 / 8) + 32,
        top: position.dy + 80,
        width: size.width * 4 / 8,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: _buildSearchResults(),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isSearchResultsVisible = true;
    });
  }

  void _hideSearchResults() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isSearchResultsVisible = false;
    });
  }

  void _onRestaurantTap(Restaurant restaurant) {
    final controller = Provider.of<RestaurantController>(
      context,
      listen: false,
    );
    controller.selectRestaurant(restaurant);
    _hideSearchResults();
    _searchFocusNode.unfocus();
  }

  void _onFoodTap(Food food) {
    final controller = Provider.of<RestaurantController>(
      context,
      listen: false,
    );
    controller.selectFood(food);
    _hideSearchResults();
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: [
            Expanded(flex: 3, child: _buildDeliveryAddress()),
            const SizedBox(width: 32),
            Expanded(flex: 4, child: _buildSearchBar()),
            const SizedBox(width: 32),
            Expanded(flex: 1, child: _buildNotificationSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFF4444),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.location_on_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Delivery Address',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '123 Main Street, New York',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF6B7280),
          size: 20,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Consumer<RestaurantController>(
      builder: (context, controller, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isSearchFocused
                  ? const Color(0xFFFF4444)
                  : const Color(0xFFE5E7EB),
              width: _isSearchFocused ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                Icons.search_rounded,
                color: _isSearchFocused
                    ? const Color(0xFFFF4444)
                    : const Color(0xFF9CA3AF),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: (value) {
                    controller.searchRestaurantsAndFoods(value);
                    if (value.isNotEmpty && !_isSearchResultsVisible) {
                      _showSearchResults();
                    } else if (value.isEmpty && _isSearchResultsVisible) {
                      _hideSearchResults();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for restaurants, cuisines or dishes',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
              if (controller.searchQuery.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    controller.clearSearch();
                    _hideSearchResults();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.close_rounded,
                      color: Color(0xFF9CA3AF),
                      size: 20,
                    ),
                  ),
                ),
              const SizedBox(width: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return Consumer<RestaurantController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final restaurantsToShow = controller.searchQuery.isEmpty
            ? controller.restaurants
            : controller.filteredRestaurants;

        final foodsToShow = controller.searchQuery.isEmpty
            ? controller.restaurants.expand((r) => r.foods).toList()
            : controller.filteredFoods;

        if (restaurantsToShow.isEmpty &&
            foodsToShow.isEmpty &&
            controller.searchQuery.isNotEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'No results found',
                    style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (restaurantsToShow.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    controller.searchQuery.isEmpty
                        ? 'All Restaurants'
                        : 'Restaurants',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
                ...restaurantsToShow
                    .take(3)
                    .map((restaurant) => _buildRestaurantItem(restaurant)),
                if (restaurantsToShow.length > 3)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      '+${restaurantsToShow.length - 3} more restaurants',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),
              ],
              if (foodsToShow.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    controller.searchQuery.isEmpty ? 'All Foods' : 'Foods',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ),
                ...foodsToShow
                    .take(5)
                    .map((food) => _buildFoodItem(food, controller)),
                if (foodsToShow.length > 5)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      '+${foodsToShow.length - 5} more dishes',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildRestaurantItem(Restaurant restaurant) {
    return InkWell(
      onTap: () => _onRestaurantTap(restaurant),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1),
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: restaurant.logoFullUrl.isNotEmpty
                  ? Image.network(
                      restaurant.logoFullUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 40,
                          height: 40,
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(
                            Icons.restaurant,
                            color: Color(0xFF9CA3AF),
                            size: 20,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 40,
                      height: 40,
                      color: const Color(0xFFF3F4F6),
                      child: const Icon(
                        Icons.restaurant,
                        color: Color(0xFF9CA3AF),
                        size: 20,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber[700], size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant.avgRating.toStringAsFixed(1)} • ${restaurant.deliveryTime}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF9CA3AF),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItem(Food food, RestaurantController controller) {
    final restaurant = controller.getRestaurantForFood(food);

    return InkWell(
      onTap: () => _onFoodTap(food),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1),
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: food.imageFullUrl.isNotEmpty
                  ? Image.network(
                      food.imageFullUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 40,
                          height: 40,
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(
                            Icons.fastfood,
                            color: Color(0xFF9CA3AF),
                            size: 20,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 40,
                      height: 40,
                      color: const Color(0xFFF3F4F6),
                      child: const Icon(
                        Icons.fastfood,
                        color: Color(0xFF9CA3AF),
                        size: 20,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    food.description.isEmpty
                        ? 'From ${restaurant?.name ?? "Unknown Restaurant"}'
                        : food.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF6B7280),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF9CA3AF),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isNotificationHovered = true),
          onExit: (_) => setState(() => _isNotificationHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _isNotificationHovered
                  ? const Color(0xFFF3F4F6)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications_outlined,
                    size: 24,
                    color: Color(0xFF374151),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WebHeaderDemo extends StatelessWidget {
  const WebHeaderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const WebHeaderWidget(),
          Expanded(
            child: Container(
              color: const Color(0xFFF9FAFB),
              child: const Center(
                child: Text(
                  'Page Content Here',
                  style: TextStyle(fontSize: 24, color: Color(0xFF6B7280)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
