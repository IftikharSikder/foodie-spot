import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/features/popular/domain/repository/popular_food_repository.dart';
import 'package:food_delivery/styles/app_theme.dart';
import 'package:provider/provider.dart';

import 'app/app_routes.dart';
import 'features/banner/controllers/banner_controller.dart';
import 'features/banner/domain/repository/banner_repository.dart';
import 'features/banner/domain/service/banner_service.dart';
import 'features/categories/controller/category_controller.dart';
import 'features/categories/domain/repository/category_repository.dart';
import 'features/categories/domain/service/category_service.dart';
import 'features/food_campaign/controller/food_campaign_controller.dart';
import 'features/food_campaign/domain/repository/food_campaign_repository.dart';
import 'features/food_campaign/domain/service/food_campaign_service.dart';
import 'features/popular/controller/popular_food_controller.dart';
import 'features/restaurant_food/controller/restaurant_controller.dart';
import 'helper/network_info.dart';

//I need to internet connectivity
//I need to stop rotating phone [done]
//Screen util for responsive size
//App theme mush be set
//After navigation same screen position
//remove all print from console
//checking internet connectivity
//fixing router

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InternetProvider()),
        ChangeNotifierProvider(
          create: (context) => BannerController(
            bannerService: BannerService(bannerRepository: BannerRepository()),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              CategoryController(CategoryService(CategoryRepository())),
        ),
        ChangeNotifierProvider(
          create: (context) => PopularFoodController(PopularFoodRepository()),
        ),
        ChangeNotifierProvider(
          create: (context) => FoodCampaignController(
            service: FoodCampaignService(
              repository: FoodCampaignRepository(
                dio: Dio(), // Your configured Dio instance
              ),
            ),
          ),
        ),
        // ChangeNotifierProvider(create: (_) => RestaurantController()),
        ChangeNotifierProvider(create: (context) => RestaurantController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouters.router,
          theme: appTheme,
        );
      },
    );
  }
}
