import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/base_widgets/custom_snackbar_widgets.dart';
import '../../constants/app_strings.dart';
import '../../features/banner/widgets/banner_carousel_widget.dart';
import '../../features/categories/widgets/horizontal_categories_widget.dart';
import '../../features/popular/controller/popular_food_controller.dart';
import '../../features/popular/widgets/horizontal_popular_food_widget.dart';
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

        return const Scaffold(
          body: Column(
            children: [
              BannerCarouselWidget(),
              HorizontalCategoryWidget(),
              HorizontalPopularFoodWidget(),
            ],
          ),
        );
      },
    );
  }
}
