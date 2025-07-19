import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../helper/network_info.dart';
import '../../app/popular/controller/popular_food_controller.dart';
import '../../app/popular/domain/models/popular_food_model.dart';

class WebPopularFoodWidget extends StatefulWidget {
  const WebPopularFoodWidget({super.key});

  @override
  State<WebPopularFoodWidget> createState() => _WebPopularFoodWidgetState();
}

class _WebPopularFoodWidgetState extends State<WebPopularFoodWidget> {
  bool _retryTriggered = false;
  bool _showViewAll = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final popularFoodController = context.read<PopularFoodController>();
    final internetProvider = context.watch<InternetProvider>();

    final shouldRetry =
        internetProvider.hasConnection &&
        popularFoodController.hasNetworkError &&
        popularFoodController.error.isNotEmpty &&
        !_retryTriggered;

    if (shouldRetry) {
      _retryTriggered = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await popularFoodController.silentRetry();

        if (mounted) {
          setState(() {
            _retryTriggered = false;
          });
        }
      });
    }
  }

  void _toggleViewAll() {
    setState(() {
      _showViewAll = !_showViewAll;
    });

    if (!_showViewAll) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _loadData() {
    final internetProvider = Provider.of<InternetProvider>(
      context,
      listen: false,
    );
    final popularFoodController = Provider.of<PopularFoodController>(
      context,
      listen: false,
    );

    if (internetProvider.hasConnection) {
      popularFoodController.getPopularFoods();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 1200;
    final isMediumScreen = screenWidth > 800;

    return Consumer2<PopularFoodController, InternetProvider>(
      builder: (context, popularFoodController, internetProvider, child) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isLargeScreen ? 80 : (isMediumScreen ? 40 : 20),
            vertical: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _showViewAll ? 'All Popular Foods' : 'Popular Food Nearby',
                    style: GoogleFonts.poppins(
                      fontSize: isLargeScreen ? 32 : (isMediumScreen ? 28 : 24),
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  if (!_showViewAll)
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _toggleViewAll,
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
                  if (_showViewAll)
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _toggleViewAll,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 24,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 32),

              if (popularFoodController.isLoading ||
                  (popularFoodController.hasNetworkError &&
                      popularFoodController.popularFoods.isEmpty))
                _buildShimmerGrid(isLargeScreen, isMediumScreen)
              else if (popularFoodController.error.isNotEmpty &&
                  popularFoodController.popularFoods.isEmpty &&
                  !popularFoodController.hasNetworkError)
                _buildErrorState()
              else if (popularFoodController.popularFoods.isEmpty &&
                  popularFoodController.error.isEmpty)
                _buildEmptyState()
              else if (_showViewAll)
                _buildGridView(
                  popularFoodController.popularFoods,
                  isLargeScreen,
                  isMediumScreen,
                )
              else
                _buildHorizontalList(
                  popularFoodController.popularFoods,
                  isLargeScreen,
                  isMediumScreen,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHorizontalList(
    List<PopularFoodModel> foods,
    bool isLargeScreen,
    bool isMediumScreen,
  ) {
    final itemWidth = isLargeScreen ? 280.0 : (isMediumScreen ? 240.0 : 200.0);
    final itemHeight = isLargeScreen ? 350.0 : (isMediumScreen ? 320.0 : 280.0);

    return SizedBox(
      height: itemHeight,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: foods.length > 8 ? 8 : foods.length,
        itemBuilder: (context, index) {
          final popularFood = foods[index];
          return Container(
            width: itemWidth,
            margin: const EdgeInsets.only(right: 24),
            child: _WebPopularFoodItemWidget(
              popularFood: popularFood,
              isLarge: isLargeScreen,
              isMedium: isMediumScreen,
            ),
          );
        },
      ),
    );
  }

  Widget _buildGridView(
    List<PopularFoodModel> foods,
    bool isLargeScreen,
    bool isMediumScreen,
  ) {
    int crossAxisCount = isLargeScreen ? 4 : (isMediumScreen ? 3 : 2);
    double childAspectRatio = isLargeScreen
        ? 0.8
        : (isMediumScreen ? 0.75 : 0.7);

    return GridView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final popularFood = foods[index];
        return _WebPopularFoodItemWidget(
          popularFood: popularFood,
          isLarge: isLargeScreen,
          isMedium: isMediumScreen,
        );
      },
    );
  }

  Widget _buildShimmerGrid(bool isLargeScreen, bool isMediumScreen) {
    int crossAxisCount = _showViewAll
        ? (isLargeScreen ? 4 : (isMediumScreen ? 3 : 2))
        : (isLargeScreen ? 4 : (isMediumScreen ? 3 : 2));

    return _showViewAll
        ? GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: isLargeScreen
                  ? 0.8
                  : (isMediumScreen ? 0.75 : 0.7),
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemCount: 8,
            itemBuilder: (context, index) => _buildShimmerItem(),
          )
        : SizedBox(
            height: isLargeScreen ? 350 : (isMediumScreen ? 320 : 280),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  width: isLargeScreen ? 280 : (isMediumScreen ? 240 : 200),
                  margin: const EdgeInsets.only(right: 24),
                  child: _buildShimmerItem(),
                );
              },
            ),
          );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 120,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 60,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
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
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Please try again',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[500]),
            ),
            const SizedBox(height: 32),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  context.read<PopularFoodController>().clearError();
                  _loadData();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Retry',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'No popular foods found',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _WebPopularFoodItemWidget extends StatefulWidget {
  final PopularFoodModel popularFood;
  final bool isLarge;
  final bool isMedium;

  const _WebPopularFoodItemWidget({
    required this.popularFood,
    required this.isLarge,
    required this.isMedium,
  });

  @override
  State<_WebPopularFoodItemWidget> createState() =>
      _WebPopularFoodItemWidgetState();
}

class _WebPopularFoodItemWidgetState extends State<_WebPopularFoodItemWidget>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.isLarge ? 18.0 : (widget.isMedium ? 16.0 : 14.0);
    final smallFontSize = widget.isLarge
        ? 14.0
        : (widget.isMedium ? 12.0 : 10.0);

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? Colors.black.withValues(alpha: 0.15)
                        : Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: _isHovered ? 3 : 1,
                    blurRadius: _isHovered ? 12 : 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Image.network(
                              widget.popularFood.imageFullUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.fastfood,
                                    size: widget.isLarge ? 50 : 40,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                            if (widget.popularFood.discount > 0)
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${widget.popularFood.discount.toInt()}% OFF',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: widget.popularFood.veg == 1
                                        ? Colors.green
                                        : Colors.red,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: widget.popularFood.veg == 1
                                          ? Colors.green
                                          : Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(widget.isLarge ? 16 : 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.popularFood.name,
                            style: GoogleFonts.poppins(
                              fontSize: fontSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.popularFood.restaurantName,
                            style: GoogleFonts.poppins(
                              fontSize: smallFontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${widget.popularFood.price.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.popularFood.avgRating
                                          .toStringAsFixed(1),
                                      style: GoogleFonts.poppins(
                                        fontSize: smallFontSize,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
