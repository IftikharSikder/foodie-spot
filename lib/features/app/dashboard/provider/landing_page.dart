import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_dimensions.dart';
import '../../navigation/screens/cart_screen.dart';
import '../../navigation/screens/favourite_screen.dart';
import '../../navigation/screens/home_screen.dart';
import '../../navigation/screens/more_screen.dart';
import '../../navigation/screens/order_screen.dart';
import 'navigation_provider.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  final List<Widget> pages = [
    HomeScreen(),
    FavouriteScreen(),
    CartScreen(),
    OrderScreen(),
    MoreScreen(),
  ];

  final List<IconData> iconList = const [
    Icons.home,
    Icons.favorite,
    Icons.receipt_long_rounded,
    Icons.menu,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
          return pages[navigationProvider.currentIndex];
        },
      ),
      bottomNavigationBar: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: AppDimensions.bottomNavHeight,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, -1.h),
                      blurRadius: AppDimensions.shadowBlurRadius,
                      spreadRadius: AppDimensions.shadowSpreadRadius,
                      color: AppColors.shadowColor,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(0, iconList[0], navigationProvider),
                    _buildNavItem(1, iconList[1], navigationProvider),
                    SizedBox(width: AppDimensions.fabSize),
                    _buildNavItem(3, iconList[2], navigationProvider),
                    _buildNavItem(4, iconList[3], navigationProvider),
                  ],
                ),
              ),
              Positioned(
                top: AppDimensions.fabTopOffset,
                left: (1.sw / 2) - (AppDimensions.fabSize / 2),
                child: GestureDetector(
                  onTap: () {
                    navigationProvider.updateIndex(2);
                  },
                  child: Container(
                    width: AppDimensions.fabSize,
                    height: AppDimensions.fabSize,
                    decoration: const BoxDecoration(
                      color: AppColors.navigationActive,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_cart,
                      color: AppColors.background,
                      size: AppDimensions.homeIconSize,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    NavigationProvider navigationProvider,
  ) {
    final isActive = navigationProvider.currentIndex == index;
    final color = isActive
        ? AppColors.navigationActive
        : AppColors.navigationInactive;

    return GestureDetector(
      onTap: () => navigationProvider.updateIndex(index),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.menuItemPadding,
          vertical: AppDimensions.subtitleFont,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppDimensions.homeIconSize, color: color),
          ],
        ),
      ),
    );
  }
}
