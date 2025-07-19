import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/app/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_dimensions.dart';
import '../controller/food_campaign_controller.dart';
import '../widgets/food_campaign_shimmer_widget.dart';

class FoodCampaignViewAllScreen extends StatefulWidget {
  const FoodCampaignViewAllScreen({super.key});

  @override
  State<FoodCampaignViewAllScreen> createState() =>
      _FoodCampaignViewAllScreenState();
}

class _FoodCampaignViewAllScreenState extends State<FoodCampaignViewAllScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodCampaignController>().getFoodCampaigns();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Campaign',
          style: TextStyle(
            fontSize: AppDimensions.menuTitleSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.goNamed(Screens.dashboard.name);
          },
          icon: Icon(Icons.arrow_back_ios, size: AppDimensions.homeIconSize),
        ),
      ),
      body: Consumer<FoodCampaignController>(
        builder: (context, controller, child) {
          if (controller.isLoading || !controller.hasConnection) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const FoodCampaignShimmerWidget(),
                  SizedBox(height: AppDimensions.spacingLarge),
                  const FoodCampaignShimmerWidget(),
                  SizedBox(height: AppDimensions.spacingLarge),
                  const FoodCampaignShimmerWidget(),
                ],
              ),
            );
          }

          if (controller.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: AppDimensions.emptyStateIconSize,
                    color: AppColors.notificationDot,
                  ),
                  SizedBox(height: AppDimensions.spacingSmall * 2),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: AppDimensions.emptyStateTitleSize,
                      fontWeight: FontWeight.w600,
                      color: AppColors.title,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingSmall),
                  Text(
                    'Please try again later',
                    style: TextStyle(
                      fontSize: AppDimensions.searchFontSize,
                      color: AppColors.textGrey,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spacingLarge),
                  ElevatedButton(
                    onPressed: () => controller.refreshCampaigns(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.background,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.campaigns.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.campaign_outlined,
                    size: AppDimensions.emptyStateIconSize,
                    color: AppColors.iconGrey,
                  ),
                  SizedBox(height: AppDimensions.spacingSmall * 2),
                  Text(
                    'No campaigns available',
                    style: TextStyle(
                      fontSize: AppDimensions.emptyStateTitleSize,
                      fontWeight: FontWeight.w600,
                      color: AppColors.iconGrey,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.refreshCampaigns(),
            color: AppColors.primary,
            child: GridView.builder(
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
              ),
              itemCount: controller.campaigns.length,
              itemBuilder: (context, index) {
                final campaign = controller.campaigns[index];
                return _buildCampaignCard(campaign);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCampaignCard(dynamic campaign) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.restaurantCardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: AppDimensions.shadowBlurRadius,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.restaurantCardRadius),
        child: Container(
          color: AppColors.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.secondary.withValues(alpha: 0.8),
                        AppColors.primary.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: campaign.imageFullUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              color: AppColors.background,
                              strokeWidth: 2.w,
                            ),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Icon(
                              Icons.restaurant_menu,
                              size: AppDimensions.selectedItemIconSize,
                              color: AppColors.background.withValues(
                                alpha: 0.9,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.notificationDot,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '${campaign.discount ?? 20}% OFF',
                            style: TextStyle(
                              color: AppColors.background,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.menuItemPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign.name ?? 'Campaign Name',
                        style: TextStyle(
                          fontSize: AppDimensions.searchFontSize,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textTitleMedium,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),

                      Expanded(
                        child: Text(
                          campaign.description ??
                              'Delicious food campaign with amazing taste',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textGrey,
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: AppDimensions.spacingSmall),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '\$${campaign.discountedPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: AppDimensions.searchFontSize,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.navigationActive.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.menuItemRadius,
                              ),
                            ),
                            child: Text(
                              'Active',
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: AppColors.navigationActive,
                                fontWeight: FontWeight.w500,
                              ),
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
      ),
    );
  }
}
