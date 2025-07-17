import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/banner_controller.dart';
import '../domain/models/banner_model.dart';
import '../screen/banner_details_screen.dart';
import 'banner_shimmer_widget.dart';

class BannerCarouselWidget extends StatefulWidget {
  const BannerCarouselWidget({super.key});

  @override
  State<BannerCarouselWidget> createState() => _BannerCarouselWidgetState();
}

class _BannerCarouselWidgetState extends State<BannerCarouselWidget> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BannerController>().fetchBanners();
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (_pageController.hasClients) {
        final bannerController = context.read<BannerController>();
        if (bannerController.banners.isNotEmpty) {
          _currentPage = (_currentPage + 1) % bannerController.banners.length;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
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
    _startAutoScroll();
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const BannerListShimmer();
        }

        if (controller.error.isNotEmpty) {
          return _buildErrorWidget(controller);
        }

        if (controller.banners.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            Container(
              height: 180,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  _currentPage = index;
                  controller.setCurrentIndex(index);
                  _resetAutoScroll();
                },
                itemCount: controller.banners.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = _pageController.page! - index;
                        value = (1 - (value.abs() * 0.1)).clamp(0.0, 1.0);
                      }

                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value,
                          child: _buildBannerCard(
                            context,
                            controller.banners[index],
                            controller,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Page indicator
            if (controller.banners.length > 1)
              SmoothPageIndicator(
                controller: _pageController,
                count: controller.banners.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.orange,
                  dotColor: Colors.grey,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildBannerCard(
    BuildContext context,
    BannerModel banner,
    BannerController controller,
  ) {
    String imageUrl = banner.imageFullUrl;
    if (imageUrl.isEmpty && banner.image != null && banner.image!.isNotEmpty) {
      imageUrl =
          'https://stackfood-admin.6amtech.com/storage/app/public/banner/${banner.image}';
    }

    return GestureDetector(
      onTap: () {
        _stopAutoScroll();
        controller.handleBannerClick(banner);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BannerDetailScreen(banner: banner),
          ),
        ).then((_) {
          _startAutoScroll();
        });
      },
      onPanStart: (_) => _stopAutoScroll(),
      onPanEnd: (_) => _resetAutoScroll(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('Banner image load error: $error for URL: $imageUrl');
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 48,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Image not available',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 48,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No image available',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BannerController controller) {
    return Container(
      height: 180,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.grey[400], size: 48),
          const SizedBox(height: 16),
          Text(
            'Failed to load banners',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.error,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.refreshBanners(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
