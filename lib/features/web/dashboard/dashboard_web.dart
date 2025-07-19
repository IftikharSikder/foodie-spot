import 'package:flutter/material.dart';

import '../address/address_widget_web.dart';
import '../banner/screen/web_banner_carousel_widget.dart';

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
            //WebHorizontalCategoryWidget()
          ],
        ),
      ),
    );
  }
}
