import 'package:go_router/go_router.dart';

import '../features/app/banner/domain/models/banner_model.dart';
import '../features/app/banner/screen/banner_details_screen.dart';
import '../features/app/categories/screen/category_view_all_screen.dart';
import '../features/app/dashboard/screens/dashboard.dart';
import '../features/app/food_campaign/screen/food_campaign_view_all_screen.dart';
import '../features/app/popular/screen/popular_food_view_all_screen.dart';
import '../features/app/restaurant_food/domain/models/restaurant_model.dart';
import '../features/app/restaurant_food/screen/restaurant_details_screen.dart';
import '../features/app/restaurant_food/screen/search_screen.dart';
import '../features/app/splash/splash_screen.dart';

enum Screens {
  splash,
  dashboard,
  search,
  restaurantDetails,
  bannerDetails,
  categoryViewAllScreen,
  popularFoodViewAllScreen,
  foodCampaignViewAllScreen,
}

class AppRouters {
  static GoRouter router = GoRouter(
    initialLocation: "/splash",
    routes: [
      GoRoute(
        name: Screens.splash.name,
        path: "/splash",
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        name: Screens.dashboard.name,
        path: "/dashboard",
        builder: (context, state) => Dashboard(),
      ),
      GoRoute(
        name: Screens.search.name,
        path: "/search",
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        name: Screens.restaurantDetails.name,
        path: '/restaurant-details',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final restaurant = extra['restaurant'] as Restaurant?;
          final selectedFood = extra['selectedFood'] as Food?;

          return RestaurantDetailsScreen(
            restaurant: restaurant!,
            selectedFood: selectedFood,
          );
        },
      ),
      GoRoute(
        name: Screens.bannerDetails.name,
        path: '/banner-details',
        builder: (context, state) {
          final banner = state.extra as BannerModel;
          return BannerDetailScreen(banner: banner);
        },
      ),
      GoRoute(
        name: Screens.categoryViewAllScreen.name,
        path: "/category-view-all-screen",
        builder: (context, state) => const CategoryViewAllScreen(),
      ),
      GoRoute(
        name: Screens.popularFoodViewAllScreen.name,
        path: "/popular-food-view-all-screen",
        builder: (context, state) => const PopularFoodViewAllScreen(),
      ),
      GoRoute(
        name: Screens.foodCampaignViewAllScreen.name,
        path: "/food-campaign-view-all-screen",
        builder: (context, state) => const FoodCampaignViewAllScreen(),
      ),
    ],
  );
}
