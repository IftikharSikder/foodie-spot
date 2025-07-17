import 'package:go_router/go_router.dart';
import '../screens/app/home_screen.dart';
import '../screens/app/splash_screen.dart';

enum screen { splash, home }

class AppRouters {
  static GoRouter router = GoRouter(
    initialLocation: "/splash",
    routes: [
      GoRoute(
        name: screen.splash.name,
        path: "/splash",
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        name: screen.home.name,
        path: "/home",
        builder: (context, state) => HomeScreen(),
      ),
    ],
  );
}
