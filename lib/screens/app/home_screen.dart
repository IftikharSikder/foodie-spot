// // import 'package:flutter/material.dart';
// // import 'package:food_delivery/features/address/widgets/address_widget.dart';
// // import 'package:food_delivery/features/restaurant_food/widgets/search_widgets.dart';
// // import 'package:provider/provider.dart';
// //
// // import '../../common/base_widgets/custom_snackbar_widgets.dart';
// // import '../../constants/app_strings.dart';
// // import '../../features/banner/widgets/banner_carousel_widget.dart';
// // import '../../features/categories/widgets/horizontal_categories_widget.dart';
// // import '../../features/food_campaign/widgets/horizontal_food_campaign_widget.dart';
// // import '../../features/popular/controller/popular_food_controller.dart';
// // import '../../features/popular/widgets/horizontal_popular_food_widget.dart';
// // import '../../features/restaurant_food/controller/restaurant_controller.dart';
// // import '../../features/restaurant_food/widgets/food_listing_widget.dart';
// // import '../../helper/network_info.dart';
// //
// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});
// //
// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }
// //
// // class _HomeScreenState extends State<HomeScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       context.read<PopularFoodController>().getPopularFoods();
// //       context.read<RestaurantController>().initializeData();
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer<InternetProvider>(
// //       builder: (context, internetProvider, child) {
// //         WidgetsBinding.instance.addPostFrameCallback((_) {
// //           final isConnected = internetProvider.hasConnection;
// //
// //           if (isConnected != internetProvider.lastStatus) {
// //             internetProvider.setLastStatus(isConnected);
// //
// //             customSnackBar(
// //               AppStrings.noInternetMsg,
// //               isError: !isConnected,
// //               context,
// //             );
// //           }
// //         });
// //
// //         return Scaffold(
// //           body: Column(
// //             children: [
// //               Container(
// //                 padding: EdgeInsets.only(
// //                   top: MediaQuery.of(context).padding.top,
// //                   left: 12,
// //                   right: 12,
// //                 ),
// //                 child: Column(children: [AddressWidget(), SearchWidgets()]),
// //               ),
// //
// //               Expanded(
// //                 child: ListView(
// //                   padding: EdgeInsets.symmetric(horizontal: 16),
// //                   children: const [
// //                     BannerCarouselWidget(),
// //                     HorizontalCategoryWidget(),
// //                     HorizontalPopularFoodWidget(),
// //                     HorizontalFoodCampaignWidget(),
// //                     FoodListingWidget(),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
import 'package:flutter/material.dart';
import 'package:food_delivery/features/address/widgets/address_widget.dart';
import 'package:food_delivery/features/restaurant_food/widgets/search_widgets.dart';
import 'package:provider/provider.dart';

import '../../common/base_widgets/custom_snackbar_widgets.dart';
import '../../constants/app_strings.dart';
import '../../features/banner/widgets/banner_carousel_widget.dart';
import '../../features/categories/widgets/horizontal_categories_widget.dart';
import '../../features/food_campaign/widgets/horizontal_food_campaign_widget.dart';
import '../../features/popular/controller/popular_food_controller.dart';
import '../../features/popular/widgets/horizontal_popular_food_widget.dart';
import '../../features/restaurant_food/controller/restaurant_controller.dart';
import '../../features/restaurant_food/widgets/food_listing_widget.dart';
import '../../helper/network_info.dart';

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
          body: Column(
            children: [
              // Fixed header section
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 16,
                  right: 16,
                ),
                child: Column(children: [AddressWidget(), SearchWidgets()]),
              ),

              // Scrollable content with consistent padding
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ), // Apply consistent padding here
                  children: const [
                    BannerCarouselWidget(),
                    HorizontalCategoryWidget(),
                    HorizontalPopularFoodWidget(),
                    HorizontalFoodCampaignWidget(),
                    FoodListingWidget(), // Now this widget has no internal horizontal padding
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
