import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../common/base_widgets/custom_snackbar_widgets.dart';
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
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BannerController>().fetchBanners();
      _startAutoScroll();
    });

    // Listen to connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (results.any((result) => result != ConnectivityResult.none) &&
          _hasError) {
        // Internet connection restored and we had an error previously
        _hasError = false;
        context.read<BannerController>().fetchBanners();
      }
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
    _connectivitySubscription.cancel();
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
          // Mark that we have an error
          _hasError = true;

          // Show error using custom snackbar
          WidgetsBinding.instance.addPostFrameCallback((_) {
            customSnackBar(controller.error, context, isError: true);
          });

          // Show shimmer instead of error widget when there's an error
          return const BannerListShimmer();
        } else {
          // Reset error flag when data loads successfully
          _hasError = false;
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
                    // Show error snackbar for individual image load failures
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      customSnackBar(
                        'Failed to load banner image',
                        context,
                        isError: true,
                      );
                    });

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
}
