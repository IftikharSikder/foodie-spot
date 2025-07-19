import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../app/app_routes.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_dimensions.dart';
import '../../../../constants/app_strings.dart';
import '../controllers/banner_controller.dart';
import '../domain/models/banner_model.dart';
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
    _pageController = PageController(
      viewportFraction: AppDimensions.bannerViewportFraction,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BannerController>().fetchBanners();
      _startAutoScroll();
    });

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (results.any((result) => result != ConnectivityResult.none) &&
          _hasError) {
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
          _hasError = true;
          return const BannerListShimmer();
        } else {
          _hasError = false;
        }

        if (controller.banners.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            SizedBox(
              height: AppDimensions.bannerHeight,
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
                        value =
                            (1 -
                                    (value.abs() *
                                        AppDimensions.bannerScaleEffect))
                                .clamp(0.0, 1.0);
                      }

                      return Transform.scale(
                        scale: value,
                        child: Visibility(
                          visible: value > 0.0,
                          maintainState: true,
                          maintainAnimation: true,
                          maintainSize: true,
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
            SizedBox(height: AppDimensions.bannerIndicatorSpacing),

            if (controller.banners.length > 1)
              SmoothPageIndicator(
                controller: _pageController,
                count: controller.banners.length > 3
                    ? 3
                    : controller.banners.length,
                effect: WormEffect(
                  dotHeight: AppDimensions.bannerIndicatorDotHeight,
                  dotWidth: AppDimensions.bannerIndicatorDotWidth,
                  spacing: AppDimensions.iconSpacing,
                  activeDotColor: AppColors.navigationActive,
                  dotColor: AppColors.bannerIndicatorInactive,
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
    if (imageUrl.isEmpty && banner.image.isNotEmpty) {
      imageUrl =
          'https://stackfood-admin.6amtech.com/storage/app/public/banner/${banner.image}';
    }

    return GestureDetector(
      onTap: () async {
        _stopAutoScroll();
        controller.handleBannerClick(banner);
        await context.pushNamed(Screens.bannerDetails.name, extra: banner);
        _startAutoScroll();
      },
      onPanStart: (_) => _stopAutoScroll(),
      onPanEnd: (_) => _resetAutoScroll(),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppDimensions.notificationDotSize,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            AppDimensions.restaurantCardRadius,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: AppDimensions.shadowBlurRadius,
              offset: Offset(0, AppDimensions.bannerShadowOffsetY),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            AppDimensions.restaurantCardRadius,
          ),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColors.searchBackground,
                      child: child,
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {});

                    return Container(
                      color: AppColors.searchBackground,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              color: AppColors.navigationInactive,
                              size: AppDimensions.bannerErrorIconSize,
                            ),
                            SizedBox(height: AppDimensions.spacingSmall),
                            Text(
                              AppStrings.imageNotAvailable,
                              style: TextStyle(
                                color: AppColors.navigationInactive,
                                fontSize: AppDimensions.searchFontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  color: AppColors.bannerPlaceholderBackground,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          color: AppColors.navigationInactive,
                          size: AppDimensions.bannerErrorIconSize,
                        ),
                        SizedBox(height: AppDimensions.spacingSmall),
                        Text(
                          AppStrings.noImageAvailable,
                          style: TextStyle(
                            color: AppColors.navigationInactive,
                            fontSize: AppDimensions.iconSpacing,
                          ),
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
