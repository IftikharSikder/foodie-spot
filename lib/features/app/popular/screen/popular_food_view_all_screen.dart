import 'package:flutter/material.dart';
import 'package:food_delivery/app/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../common/base_widgets/custom_snackbar_widgets.dart';
import '../../../../helper/network_info.dart';
import '../controller/popular_food_controller.dart';
import '../widgets/popular_food_item_widget.dart';
import '../widgets/popular_food_shimmer_widget.dart';

class PopularFoodViewAllScreen extends StatefulWidget {
  const PopularFoodViewAllScreen({super.key});

  @override
  State<PopularFoodViewAllScreen> createState() =>
      _PopularFoodViewAllScreenState();
}

class _PopularFoodViewAllScreenState extends State<PopularFoodViewAllScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final internetProvider = Provider.of<InternetProvider>(
      context,
      listen: false,
    );
    final popularFoodController = Provider.of<PopularFoodController>(
      context,
      listen: false,
    );

    if (internetProvider.hasConnection) {
      popularFoodController.getPopularFoods();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Food Nearby'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.goNamed(Screens.dashboard.name);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Consumer2<PopularFoodController, InternetProvider>(
        builder: (context, popularFoodController, internetProvider, child) {
          if (!internetProvider.hasConnection && internetProvider.lastStatus) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              customSnackBar('No internet connection', context, isError: true);
            });
            internetProvider.setLastStatus(false);
          }

          if (internetProvider.hasConnection && !internetProvider.lastStatus) {
            internetProvider.setLastStatus(true);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _loadData();
            });
          }

          if (popularFoodController.isLoading ||
              !internetProvider.hasConnection) {
            return const PopularFoodShimmerWidget();
          }

          if (popularFoodController.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please try again',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      popularFoodController.clearError();
                      _loadData();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (popularFoodController.popularFoods.isEmpty) {
            return const Center(
              child: Text(
                'No popular foods found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: popularFoodController.popularFoods.length,
              itemBuilder: (context, index) {
                final popularFood = popularFoodController.popularFoods[index];
                return PopularFoodItemWidget(popularFood: popularFood);
              },
            ),
          );
        },
      ),
    );
  }
}
