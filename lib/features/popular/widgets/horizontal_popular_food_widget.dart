import 'package:flutter/material.dart';
import 'package:food_delivery/features/popular/widgets/popular_food_item_widget.dart';
import 'package:food_delivery/features/popular/widgets/popular_food_shimmer_widget.dart';
import 'package:provider/provider.dart';

import '../../../helper/network_info.dart';
import '../controller/popular_food_controller.dart';
import '../screen/popular_food_view_all_screen.dart';

class HorizontalPopularFoodWidget extends StatefulWidget {
  const HorizontalPopularFoodWidget({Key? key}) : super(key: key);

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
        if (popularFoodController.isLoading ||
            (popularFoodController.hasNetworkError &&
                popularFoodController.popularFoods.isEmpty)) {
          return const SizedBox(height: 240, child: PopularFoodShimmerWidget());
        }

        if (popularFoodController.error.isNotEmpty &&
            popularFoodController.popularFoods.isEmpty &&
            !popularFoodController.hasNetworkError) {
          return const SizedBox(
            height: 240,
            child: Center(
              child: Text(
                'Error loading popular foods',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        if (popularFoodController.popularFoods.isEmpty &&
            popularFoodController.error.isEmpty) {
          return const SizedBox(
            height: 240,
            child: Center(
              child: Text(
                'No popular foods found',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Popular Food Nearby',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PopularFoodViewAllScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: popularFoodController.popularFoods.length,
                itemBuilder: (context, index) {
                  final popularFood = popularFoodController.popularFoods[index];
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 16),
                    child: ClipRect(
                      child: PopularFoodItemWidget(popularFood: popularFood),
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
