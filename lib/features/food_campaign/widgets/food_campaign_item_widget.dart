// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../domain/model/food_campaign_model.dart';
//
// class FoodCampaignItemWidget extends StatelessWidget {
//   final FoodCampaignModel campaign;
//
//   const FoodCampaignItemWidget({Key? key, required this.campaign})
//     : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     double discountPercentage = 0;
//     return Container(
//       height: 160,
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withValues(alpha: 0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Stack(
//             children: [
//               Container(
//                 width: 80,
//                 height: double.infinity,
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.horizontal(
//                     left: Radius.circular(12),
//                   ),
//                   child: CachedNetworkImage(
//                     imageUrl: campaign.imageFullUrl,
//                     width: 80,
//                     height: double.infinity,
//                     fit: BoxFit.cover,
//                     alignment: Alignment.center,
//                     placeholder: (context, url) => _buildImageShimmer(),
//                     errorWidget: (context, url, error) => _buildImageShimmer(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           // Content
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         campaign.name.split(' ')[0],
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         campaign.restaurantName,
//                         style: TextStyle(fontSize: 10, color: Colors.grey[600]),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                   Row(children: _buildStarRating(campaign.avgRating)),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Price
//                       Text(
//                         '\$${campaign.discountedPrice.toStringAsFixed(0)}',
//                         style: const TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//
//                       if (discountPercentage > 0)
//                         Text(
//                           '\$${campaign.price.toStringAsFixed(0)}',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[500],
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                         ),
//
//                       Container(
//                         width: 24,
//                         height: 24,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: const Icon(
//                           Icons.add,
//                           color: Colors.black,
//                           size: 20,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildImageShimmer() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(width: 80, height: 80, color: Colors.grey[300]),
//     );
//   }
//
//   List<Widget> _buildStarRating(double rating) {
//     List<Widget> stars = [];
//     int fullStars = rating.floor();
//     bool hasHalfStar = (rating - fullStars) >= 0.5;
//
//     for (int i = 0; i < fullStars && i < 5; i++) {
//       stars.add(const Icon(Icons.star, color: Colors.amber, size: 14));
//     }
//
//     if (hasHalfStar && fullStars < 5) {
//       stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 14));
//     }
//
//     int totalStars = fullStars + (hasHalfStar ? 1 : 0);
//     for (int i = totalStars; i < 5; i++) {
//       stars.add(const Icon(Icons.star_border, color: Colors.grey, size: 14));
//     }
//     return stars;
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../domain/model/food_campaign_model.dart';

class FoodCampaignItemWidget extends StatelessWidget {
  final FoodCampaignModel campaign;

  const FoodCampaignItemWidget({Key? key, required this.campaign})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate discount percentage properly
    double discountPercentage = 0;
    if (campaign.price > 0 && campaign.discountedPrice < campaign.price) {
      discountPercentage =
          ((campaign.price - campaign.discountedPrice) / campaign.price) * 100;
    }

    return Container(
      height: 160,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Container(
                width: 80,
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: campaign.imageFullUrl,
                    width: 80,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    placeholder: (context, url) => _buildImageShimmer(),
                    errorWidget: (context, url, error) => _buildImageShimmer(),
                  ),
                ),
              ),
            ],
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        campaign.name.split(' ')[0],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        campaign.restaurantName,
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(children: _buildStarRating(campaign.avgRating)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price section with both discounted and original price
                      Expanded(
                        child: Row(
                          children: [
                            // Discounted price (actual price after discount)
                            Text(
                              '\$${campaign.discountedPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            if (discountPercentage > 0) ...[
                              const SizedBox(width: 4),
                              // Original price (crossed out)
                              Text(
                                '\$${campaign.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 20,
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
    );
  }

  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(width: 80, height: 80, color: Colors.grey[300]),
    );
  }

  List<Widget> _buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars && i < 5; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 14));
    }

    if (hasHalfStar && fullStars < 5) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 14));
    }

    int totalStars = fullStars + (hasHalfStar ? 1 : 0);
    for (int i = totalStars; i < 5; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.grey, size: 14));
    }
    return stars;
  }
}
