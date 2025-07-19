import 'package:flutter/material.dart';
import 'package:food_delivery/constants/app_images.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/app_routes.dart';
import '../../../common/base_widgets/custom_snackbar_widgets.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_dimensions.dart';
import '../../../constants/app_strings.dart';
import '../../../helper/network_info.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final internetProvider = Provider.of<InternetProvider>(
        context,
        listen: false,
      );
      final isConnected = internetProvider.hasConnection;

      if (isConnected != internetProvider.lastStatus) {
        internetProvider.setLastStatus(isConnected);
        customSnackBar(
          AppStrings.noInternetMsg,
          isError: !isConnected,
          context,
        );
      }

      if (!internetProvider.navigated) {
        internetProvider.setNavigated(true);
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            context.goNamed(Screens.dashboard.name);
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile version
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _bounceAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _bounceAnimation.value,
                        child: Container(
                          width: AppDimensions.logoSize,
                          height: AppDimensions.logoSize,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: Center(
                            child: Image.asset(
                              AppImage.appLogo,
                              width: AppDimensions.imageSize,
                              height: AppDimensions.imageSize,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: AppDimensions.spacingLarge),
                  Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: AppDimensions.selectedItemIconSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.title,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingSmall),
                  Text(
                    AppStrings.tagline,
                    style: TextStyle(
                      fontSize: AppDimensions.subtitleFont,
                      color: AppColors.subtitle,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Web version - smaller sizes
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _bounceAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _bounceAnimation.value,
                        child: Container(
                          width: AppDimensions.logoSize * 0.7, // 30% smaller
                          height: AppDimensions.logoSize * 0.7,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: Center(
                            child: Image.asset(
                              AppImage.appLogo,
                              width:
                                  AppDimensions.imageSize * 0.7, // 30% smaller
                              height: AppDimensions.imageSize * 0.7,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: AppDimensions.spacingLarge * 0.8,
                  ), // Slightly smaller spacing
                  Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize:
                          AppDimensions.selectedItemIconSize *
                          0.75, // 25% smaller
                      fontWeight: FontWeight.bold,
                      color: AppColors.title,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingSmall * 0.8),
                  Text(
                    AppStrings.tagline,
                    style: TextStyle(
                      fontSize:
                          AppDimensions.subtitleFont * 0.85, // 15% smaller
                      color: AppColors.subtitle,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
