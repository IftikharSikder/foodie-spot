import 'package:flutter/material.dart';

import '../address/address_widget_web.dart';
import '../banner/widgets/web_banner_carousel_widget.dart';
import '../category/widgets/web_categories_widget.dart';
import '../popular/web_popular_food_widget.dart';

class DashboardWeb extends StatelessWidget {
  const DashboardWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            WebHeaderWidget(),
            WebBannerCarouselWidget(),
            WebCategoriesWidget(),
            WebPopularFoodWidget(),
          ],
        ),
      ),
    );
  }
}
