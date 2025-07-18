import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/food_campaign_controller.dart';
import '../screen/food_campaign_view_all_screen.dart';
import '../widgets/food_campaign_item_widget.dart';
import '../widgets/food_campaign_shimmer_widget.dart';

class HorizontalFoodCampaignWidget extends StatefulWidget {
  const HorizontalFoodCampaignWidget({Key? key}) : super(key: key);

  @override
  State<HorizontalFoodCampaignWidget> createState() =>
      _HorizontalFoodCampaignWidgetState();
}

class _HorizontalFoodCampaignWidgetState
    extends State<HorizontalFoodCampaignWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodCampaignController>().getFoodCampaigns();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodCampaignController>(
      builder: (context, controller, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  if (controller.campaigns.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodCampaignViewAllScreen(),
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
            const SizedBox(height: 16),

            // Content
            if (controller.isLoading || !controller.hasConnection)
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
                      width: 200, // Wider for horizontal layout
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
