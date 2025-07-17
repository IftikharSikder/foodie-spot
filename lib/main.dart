import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/styles/app_theme.dart';
import 'package:provider/provider.dart';

import 'app/app_routes.dart';
import 'features/banner/controllers/banner_controller.dart';
import 'features/banner/domain/repository/banner_repository.dart';
import 'features/banner/domain/service/banner_service.dart';
import 'helper/network_info.dart';

//I need to internet connectivity
//I need to stop rotating phone [done]
//Screen util for responsive size
//App theme mush be set
//After navigation same screen position

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
