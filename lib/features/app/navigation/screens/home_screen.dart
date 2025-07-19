import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/base_widgets/custom_snackbar_widgets.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_dimensions.dart';
import '../../../../constants/app_strings.dart';
import '../../../../helper/network_info.dart';
import '../../address/widgets/address_widget.dart';
import '../../banner/widgets/banner_carousel_widget.dart';
import '../../categories/widgets/horizontal_categories_widget.dart';
import '../../food_campaign/widgets/horizontal_food_campaign_widget.dart';
import '../../popular/controller/popular_food_controller.dart';
import '../../popular/widgets/horizontal_popular_food_widget.dart';
import '../../restaurant_food/controller/restaurant_controller.dart';
import '../../restaurant_food/widgets/food_listing_widget.dart';
import '../../restaurant_food/widgets/search_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PopularFoodController>().getPopularFoods();
      context.read<RestaurantController>().initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, internetProvider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final isConnected = internetProvider.hasConnection;

          if (isConnected != internetProvider.lastStatus) {
            internetProvider.setLastStatus(isConnected);

            customSnackBar(
              AppStrings.noInternetMsg,
              isError: !isConnected,
              context,
            );
          }
        });

        return Scaffold(
          backgroundColor: AppColors.sBackground,
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top:
                      MediaQuery.of(context).padding.top +
                      AppDimensions.spacingSmall,
                ),
                child: Column(children: [AddressWidget(), SearchWidgets()]),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    BannerCarouselWidget(),
                    HorizontalCategoryWidget(),
                    HorizontalPopularFoodWidget(),
                    HorizontalFoodCampaignWidget(),
                    FoodListingWidget(),
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
