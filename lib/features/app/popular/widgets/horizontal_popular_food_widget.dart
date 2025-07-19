import 'package:flutter/material.dart';
import 'package:food_delivery/app/app_routes.dart';
import 'package:food_delivery/features/app/popular/widgets/popular_food_item_widget.dart';
import 'package:food_delivery/features/app/popular/widgets/popular_food_shimmer_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../helper/network_info.dart';
import '../controller/popular_food_controller.dart';

class HorizontalPopularFoodWidget extends StatefulWidget {
  const HorizontalPopularFoodWidget({super.key});

  @override
  State<HorizontalPopularFoodWidget> createState() =>
      _HorizontalPopularFoodWidgetState();
}

class _HorizontalPopularFoodWidgetState
    extends State<HorizontalPopularFoodWidget> {
  bool _retryTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final popularFoodController = context.read<PopularFoodController>();
    final internetProvider = context.watch<InternetProvider>();

    final shouldRetry =
        internetProvider.hasConnection &&
        popularFoodController.hasNetworkError &&
        popularFoodController.error.isNotEmpty &&
        !_retryTriggered;

    if (shouldRetry) {
      _retryTriggered = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await popularFoodController.silentRetry();

        if (mounted) {
          setState(() {
            _retryTriggered = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PopularFoodController, InternetProvider>(
      builder: (context, popularFoodController, internetProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, top: 4, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Popular Food Nearby',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.goNamed(Screens.popularFoodViewAllScreen.name);
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.green,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.green,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 240,
              child:
                  popularFoodController.isLoading ||
                      (popularFoodController.hasNetworkError &&
                          popularFoodController.popularFoods.isEmpty)
                  ? const PopularFoodShimmerWidget()
                  : popularFoodController.error.isNotEmpty &&
                        popularFoodController.popularFoods.isEmpty &&
                        !popularFoodController.hasNetworkError
                  ? const Center(
                      child: Text(
                        'Error loading popular foods',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : popularFoodController.popularFoods.isEmpty &&
                        popularFoodController.error.isEmpty
                  ? const Center(
                      child: Text(
                        'No popular foods found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: popularFoodController.popularFoods.length,
                      itemBuilder: (context, index) {
                        final popularFood =
                            popularFoodController.popularFoods[index];
                        return Container(
                          width: 150,
                          margin: const EdgeInsets.only(right: 16),
                          child: ClipRect(
                            child: PopularFoodItemWidget(
                              popularFood: popularFood,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
