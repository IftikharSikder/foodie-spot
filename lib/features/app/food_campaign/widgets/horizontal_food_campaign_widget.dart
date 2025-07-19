import 'package:flutter/material.dart';
import 'package:food_delivery/app/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../helper/network_info.dart';
import '../controller/food_campaign_controller.dart';
import 'food_campaign_item_widget.dart';
import 'food_campaign_shimmer_widget.dart';

class HorizontalFoodCampaignWidget extends StatefulWidget {
  const HorizontalFoodCampaignWidget({super.key});

  @override
  State<HorizontalFoodCampaignWidget> createState() =>
      _HorizontalFoodCampaignWidgetState();
}

class _HorizontalFoodCampaignWidgetState
    extends State<HorizontalFoodCampaignWidget> {
  bool _wasDisconnected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final internetProvider = context.read<InternetProvider>();
      final foodCampaignController = context.read<FoodCampaignController>();

      if (internetProvider.hasConnection) {
        foodCampaignController.getFoodCampaigns();
      } else {
        _wasDisconnected = true;
      }
    });
  }

  void _handleConnectivityChange(
    InternetProvider internetProvider,
    FoodCampaignController foodCampaignController,
  ) {
    if (internetProvider.hasConnection && _wasDisconnected) {
      _wasDisconnected = false;
      foodCampaignController.getFoodCampaigns();
    } else if (!internetProvider.hasConnection) {
      _wasDisconnected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FoodCampaignController, InternetProvider>(
      builder: (context, controller, internetProvider, child) {
        _handleConnectivityChange(internetProvider, controller);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Food Campaign',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (controller.campaigns.isNotEmpty &&
                      internetProvider.hasConnection)
                    TextButton(
                      onPressed: () {
                        context.goNamed(Screens.foodCampaignViewAllScreen.name);
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
            const SizedBox(height: 4),

            if (controller.isLoading || !internetProvider.hasConnection)
              const FoodCampaignShimmerWidget()
            else if (controller.hasError)
              Container(
                height: 150,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[50],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to load campaigns',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => controller.refreshCampaigns(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else if (controller.campaigns.isEmpty)
              Container(
                height: 150,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[50],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.campaign_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No campaigns available',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.campaigns.length,
                  itemBuilder: (context, index) {
                    final campaign = controller.campaigns[index];
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 16),
                      child: FoodCampaignItemWidget(campaign: campaign),
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
