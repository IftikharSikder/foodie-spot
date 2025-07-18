import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/food_campaign_controller.dart';
import '../widgets/food_campaign_shimmer_widget.dart';

class FoodCampaignViewAllScreen extends StatefulWidget {
  const FoodCampaignViewAllScreen({Key? key}) : super(key: key);

  @override
  State<FoodCampaignViewAllScreen> createState() =>
      _FoodCampaignViewAllScreenState();
}

class _FoodCampaignViewAllScreenState extends State<FoodCampaignViewAllScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodCampaignController>().getFoodCampaigns();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Campaign'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<FoodCampaignController>(
        builder: (context, controller, child) {
          if (controller.isLoading || !controller.hasConnection) {
            return const SingleChildScrollView(
              child: Column(
                children: [
                  FoodCampaignShimmerWidget(),
                  SizedBox(height: 20),
                  FoodCampaignShimmerWidget(),
                  SizedBox(height: 20),
                  FoodCampaignShimmerWidget(),
                ],
              ),
            );
          }

          if (controller.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please try again later',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => controller.refreshCampaigns(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.campaigns.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.campaign_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No campaigns available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.refreshCampaigns(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: controller.campaigns.length,
              itemBuilder: (context, index) {
                final campaign = controller.campaigns[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Section
                          Expanded(
                            flex: 5,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.orange.shade300,
                                    Colors.red.shade400,
                                  ],
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: CachedNetworkImage(
                                        imageUrl: campaign.imageFullUrl,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                              child: Icon(
                                                Icons.restaurant_menu,
                                                size: 32,
                                                color: Colors.white.withOpacity(
                                                  0.9,
                                                ),
                                              ),
                                            ),
                                      ),
                                    ),
                                  ),
                                  // Discount badge
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${campaign.discount ?? 20}% OFF',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Content Section
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Campaign name
                                  Text(
                                    campaign.name ?? 'Campaign Name',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),

                                  Expanded(
                                    child: Text(
                                      campaign.description ??
                                          'Delicious food campaign with amazing taste',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                        height: 1.3,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '\$${campaign.discountedPrice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),

                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          'Active',
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
