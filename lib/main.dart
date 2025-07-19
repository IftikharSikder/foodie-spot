import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/styles/app_theme.dart';
import 'package:provider/provider.dart';

import 'app/app_routes.dart';
import 'features/app/banner/controllers/banner_controller.dart';
import 'features/app/banner/domain/repository/banner_repository.dart';
import 'features/app/banner/domain/service/banner_service.dart';
import 'features/app/categories/controller/category_controller.dart';
import 'features/app/categories/domain/repository/category_repository.dart';
import 'features/app/categories/domain/service/category_service.dart';
import 'features/app/dashboard/provider/navigation_provider.dart';
import 'features/app/food_campaign/controller/food_campaign_controller.dart';
import 'features/app/food_campaign/domain/repository/food_campaign_repository.dart';
import 'features/app/food_campaign/domain/service/food_campaign_service.dart';
import 'features/app/popular/controller/popular_food_controller.dart';
import 'features/app/popular/domain/repository/popular_food_repository.dart';
import 'features/app/restaurant_food/controller/restaurant_controller.dart';
import 'helper/network_info.dart';

//After navigation same screen position
//App icon name

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InternetProvider()),
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
        ), // Add this line
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
              repository: FoodCampaignRepository(dio: Dio()),
            ),
          ),
        ),
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
