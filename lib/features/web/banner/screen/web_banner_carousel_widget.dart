import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../app/app_routes.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_strings.dart';
import '../../../app/banner/controllers/banner_controller.dart';
import '../../../app/banner/domain/models/banner_model.dart';

class WebBannerCarouselWidget extends StatefulWidget {
  const WebBannerCarouselWidget({super.key});

  @override
  State<WebBannerCarouselWidget> createState() =>
      _WebBannerCarouselWidgetState();
}

class _WebBannerCarouselWidgetState extends State<WebBannerCarouselWidget>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  Timer? _timer;
  int _currentPage = 0;
  bool _hasError = false;
  bool _isHovered = false;
  int? _hoveredIndex;

  final double _webBannerHeight = 240.0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 0.85);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updatePageController();
        context.read<BannerController>().fetchBanners();
        _startAutoScroll();
      }
    });

    html.window.onResize.listen((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _updatePageController();
          }
        });
      }
    });
  }

  void _updatePageController() {
    if (!mounted) return;

    final newViewportFraction = _getViewportFraction();
    if (_pageController.hasClients) {
      final currentPage = _pageController.page?.round() ?? 0;
      _pageController.dispose();
      _pageController = PageController(
        viewportFraction: newViewportFraction,
        initialPage: currentPage,
      );
      setState(() {
        _currentPage = currentPage;
      });
    } else {
      _pageController.dispose();
      _pageController = PageController(viewportFraction: newViewportFraction);
    }
  }

  double _getViewportFraction() {
    if (!mounted) return 0.85;

    try {
      final screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth > 1600) return 0.28;
      if (screenWidth > 1200) return 0.35;
      if (screenWidth > 900) return 0.5;
      if (screenWidth > 600) return 0.7;
      return 0.85;
    } catch (e) {
      return 0.85;
    }
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (_pageController.hasClients && !_isHovered && mounted) {
        final bannerController = context.read<BannerController>();
        if (bannerController.banners.isNotEmpty) {
          _currentPage = (_currentPage + 1) % bannerController.banners.length;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
          );
        }
      }
    });
  }

  void _stopAutoScroll() {
    _timer?.cancel();
  }

  void _resetAutoScroll() {
    _stopAutoScroll();
    if (!_isHovered) {
      _startAutoScroll();
    }
  }

  void _goToNext() {
    if (_pageController.hasClients) {
      final bannerController = context.read<BannerController>();
      if (bannerController.banners.isNotEmpty) {
        _currentPage = (_currentPage + 1) % bannerController.banners.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  void _goToPrevious() {
    if (_pageController.hasClients) {
      final bannerController = context.read<BannerController>();
      if (bannerController.banners.isNotEmpty) {
        _currentPage =
            (_currentPage - 1 + bannerController.banners.length) %
            bannerController.banners.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  void _goToPage(int index) {
    if (_pageController.hasClients) {
      _currentPage = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return _buildWebShimmer();
        }

        if (controller.error.isNotEmpty) {
          _hasError = true;
          return _buildErrorState();
        } else {
          _hasError = false;
        }

        if (controller.banners.isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildBannerCarousel(controller);
      },
    );
  }

  Widget _buildBannerCarousel(BannerController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          MouseRegion(
            onEnter: (_) {
              setState(() => _isHovered = true);
              _stopAutoScroll();
              _fadeController.forward();
            },
            onExit: (_) {
              setState(() {
                _isHovered = false;
                _hoveredIndex = null;
              });
              _startAutoScroll();
              _fadeController.reverse();
            },
            child: Stack(
              children: [
                SizedBox(
                  height: _webBannerHeight,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      controller.setCurrentIndex(index);
                      _resetAutoScroll();
                    },
                    itemCount: controller.banners.length,
                    itemBuilder: (context, index) {
                      return _buildAnimatedBannerCard(
                        context,
                        controller.banners[index],
                        controller,
                        index,
                      );
                    },
                  ),
                ),

                if (controller.banners.length > 1) ...[
                  _buildNavigationArrow(
                    alignment: Alignment.centerLeft,
                    icon: Icons.keyboard_arrow_left_rounded,
                    onPressed: _goToPrevious,
                  ),
                  _buildNavigationArrow(
                    alignment: Alignment.centerRight,
                    icon: Icons.keyboard_arrow_right_rounded,
                    onPressed: _goToNext,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (controller.banners.length > 1)
            _buildEnhancedPageIndicator(controller),
        ],
      ),
    );
  }

  Widget _buildAnimatedBannerCard(
    BuildContext context,
    BannerModel banner,
    BannerController controller,
    int index,
  ) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 1.0;
        double opacity = 1.0;

        if (_pageController.position.haveDimensions) {
          value = (_pageController.page ?? 0) - index;
          value = (1 - (value.abs() * 0.3)).clamp(0.8, 1.0);
          opacity = (1 - (value.abs() * 0.4)).clamp(0.7, 1.0);
        }

        return Transform.scale(
          scale: Curves.easeOutCubic.transform(value),
          child: Opacity(
            opacity: opacity,
            child: MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndex = index),
              onExit: (_) => setState(() => _hoveredIndex = null),
              cursor: SystemMouseCursors.click,
              child: _buildWebBannerCard(context, banner, controller, index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWebBannerCard(
    BuildContext context,
    BannerModel banner,
    BannerController controller,
    int index,
  ) {
    String imageUrl = banner.imageFullUrl;
    if (imageUrl.isEmpty && banner.image.isNotEmpty) {
      imageUrl =
          'https://stackfood-admin.6amtech.com/storage/app/public/banner/${banner.image}';
    }

    final isHovered = _hoveredIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isHovered ? 0.2 : 0.12),
            blurRadius: isHovered ? 20 : 12,
            offset: Offset(0, isHovered ? 8 : 4),
            spreadRadius: isHovered ? 1 : 0,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => _handleBannerClick(context, banner, controller),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildBannerImage(imageUrl, isHovered),
            ),

            _buildGradientOverlay(isHovered),

            _buildContentOverlay(banner, isHovered),

            if (isHovered) _buildHoverIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerImage(String imageUrl, bool isHovered) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.identity()..scale(isHovered ? 1.03 : 1.0),
      transformAlignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[50],
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orange.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildImageError();
                },
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildGradientOverlay(bool isHovered) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: isHovered ? 0.4 : 0.25),
              ],
              stops: const [0.5, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentOverlay(BannerModel banner, bool isHovered) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(isHovered ? 18 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (banner.title.isNotEmpty)
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isHovered ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  shadows: const [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black45,
                    ),
                  ],
                ),
                child: Text(
                  banner.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            if (banner.title.isNotEmpty) const SizedBox(height: 6),

            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: Colors.white.withValues(alpha: isHovered ? 0.9 : 0.85),
                fontSize: isHovered ? 14 : 12,
                height: 1.3,
                fontWeight: FontWeight.w400,
                shadows: const [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black45,
                  ),
                ],
              ),
              child: Text(
                _getBannerSubtitle(banner),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            if (isHovered) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getBannerIcon(banner),
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Explore',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHoverIndicator() {
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.open_in_new_rounded,
          size: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildNavigationArrow({
    required Alignment alignment,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: FadeTransition(
          opacity: _fadeController,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              color: Colors.black87,
              splashRadius: 20,
              padding: const EdgeInsets.all(8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedPageIndicator(BannerController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SmoothPageIndicator(
          controller: _pageController,
          count: controller.banners.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            spacing: 8,
            radius: 4,
            activeDotColor: AppColors.navigationActive,
            dotColor: AppColors.bannerIndicatorInactive.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildWebShimmer() {
    return Container(
      width: double.infinity,
      height: _webBannerHeight + 56,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  width: 280,
                  height: _webBannerHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.orange.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      width: double.infinity,
      height: _webBannerHeight + 56,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 36,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'Failed to load banners',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey[400],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.imageNotAvailable,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, color: Colors.grey[400], size: 32),
            const SizedBox(height: 8),
            Text(
              AppStrings.noImageAvailable,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _getBannerSubtitle(BannerModel banner) {
    if (banner.restaurant != null) {
      return banner.restaurant!.name;
    } else if (banner.food != null) {
      return banner.food!.name;
    } else if (banner.description.isNotEmpty) {
      return banner.description;
    }
    return 'Discover more';
  }

  IconData _getBannerIcon(BannerModel banner) {
    switch (banner.type) {
      case 'restaurant_wise':
        return Icons.restaurant;
      case 'food_wise':
        return Icons.restaurant_menu;
      default:
        return Icons.explore;
    }
  }

  Future<void> _handleBannerClick(
    BuildContext context,
    BannerModel banner,
    BannerController controller,
  ) async {
    try {
      HapticFeedback.lightImpact();
      _stopAutoScroll();

      controller.handleBannerClick(banner);

      await context.pushNamed(Screens.bannerDetails.name, extra: banner);
    } catch (e) {
      debugPrint('Navigation error: $e');
    } finally {
      if (mounted) {
        _startAutoScroll();
      }
    }
  }
}
