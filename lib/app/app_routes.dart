import 'package:go_router/go_router.dart';

import '../features/splash/splash_screen.dart';
import '../screens/app/home_screen.dart';

enum screens { splash, home }

class AppRouters {
  static GoRouter router = GoRouter(
    initialLocation: "/splash",
    routes: [
      GoRoute(
        name: screens.splash.name,
        path: "/splash",
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        name: screens.home.name,
        path: "/home",
        builder: (context, state) => HomeScreen(),
      ),
    ],
  );
}
