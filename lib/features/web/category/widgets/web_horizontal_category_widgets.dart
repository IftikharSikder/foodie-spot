// import 'dart:async';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../app/categories/controller/category_controller.dart';
// import '../../../app/categories/domain/models/category_model.dart';
//
// class WebHorizontalCategoryWidget extends StatefulWidget {
//   final VoidCallback? onViewAllTap;
//   final Function(CategoryModel)? onCategorySelected;
//   final bool showAllOption;
//
//   const WebHorizontalCategoryWidget({
//     super.key,
//     this.onViewAllTap,
//     this.onCategorySelected,
//     this.showAllOption = true,
//   });
//
//   @override
//   State<WebHorizontalCategoryWidget> createState() =>
//       _WebHorizontalCategoryWidgetState();
// }
//
// class _WebHorizontalCategoryWidgetState
//     extends State<WebHorizontalCategoryWidget> {
//   final ScrollController _scrollController = ScrollController();
//   bool _canScrollLeft = false;
//   bool _canScrollRight = true;
//   late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
//   bool _hasError = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_updateScrollButtons);
//
//     // Fetch categories when widget initializes
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<CategoryController>().fetchCategories();
//     });
//
//     // Initialize connectivity subscription
//     _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
//       List<ConnectivityResult> results,
//     ) {
//       if (results.any((result) => result != ConnectivityResult.none) &&
//           _hasError) {
//         _hasError = false;
//         context.read<CategoryController>().fetchCategories();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_updateScrollButtons);
//     _scrollController.dispose();
//     _connectivitySubscription.cancel();
//     super.dispose();
//   }
//
//   void _updateScrollButtons() {
//     setState(() {
//       _canScrollLeft = _scrollController.offset > 0;
//       _canScrollRight =
//           _scrollController.offset < _scrollController.position.maxScrollExtent;
//     });
//   }
//
//   void _scrollLeft() {
//     _scrollController.animateTo(
//       _scrollController.offset - 200,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   void _scrollRight() {
//     _scrollController.animateTo(
//       _scrollController.offset + 200,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CategoryController>(
//       builder: (context, controller, child) {
//         return Container(
//           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Categories',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ),
//                   TextButton.icon(
//                     onPressed:
//                         widget.onViewAllTap ??
//                         () => _navigateToViewAll(context),
//                     icon: const Icon(Icons.arrow_forward, size: 16),
//                     label: const Text('View All'),
//                     style: TextButton.styleFrom(
//                       foregroundColor: const Color(0xFF2563EB),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       textStyle: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//
//               SizedBox(height: 100, child: _buildContent(context, controller)),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildContent(BuildContext context, CategoryController controller) {
//     if (controller.isLoading) {
//       return _buildLoadingState();
//     }
//
//     if (controller.error.isNotEmpty) {
//       _hasError = true;
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Failed to load categories'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       });
//       return _buildLoadingState();
//     } else {
//       _hasError = false;
//     }
//
//     if (controller.parentCategories.isEmpty) {
//       return _buildEmptyState();
//     }
//
//     return _buildCategoryList(context, controller);
//   }
//
//   Widget _buildLoadingState() {
//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: 8,
//       itemBuilder: (context, index) => _buildLoadingItem(),
//     );
//   }
//
//   Widget _buildLoadingItem() {
//     return Container(
//       width: 70,
//       margin: const EdgeInsets.only(right: 12),
//       child: Column(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Container(
//             width: 50,
//             height: 12,
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(6),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.category_outlined, size: 32, color: Colors.grey[400]),
//           const SizedBox(height: 8),
//           Text(
//             'No categories available',
//             style: TextStyle(color: Colors.grey[600], fontSize: 12),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategoryList(
//     BuildContext context,
//     CategoryController controller,
//   ) {
//     final categories = controller.parentCategories;
//
//     return Stack(
//       children: [
//         SingleChildScrollView(
//           controller: _scrollController,
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: [
//               if (widget.showAllOption) _buildAllCategoryItem(controller),
//               ...categories
//                   .map(
//                     (category) => _buildCategoryItem(
//                       context: context,
//                       category: category,
//                       isSelected:
//                           controller.selectedCategory?.id == category.id,
//                       onTap: () {
//                         controller.selectCategory(category);
//                         widget.onCategorySelected?.call(category);
//                       },
//                     ),
//                   )
//                   .toList(),
//             ],
//           ),
//         ),
//
//         if (_canScrollLeft)
//           Positioned(
//             left: 0,
//             top: 0,
//             bottom: 0,
//             child: Container(
//               width: 40,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.white, Colors.white.withOpacity(0)],
//                 ),
//               ),
//               child: Center(
//                 child: _NavigationButton(
//                   icon: Icons.chevron_left,
//                   onPressed: _scrollLeft,
//                 ),
//               ),
//             ),
//           ),
//
//         if (_canScrollRight)
//           Positioned(
//             right: 0,
//             top: 0,
//             bottom: 0,
//             child: Container(
//               width: 40,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.centerLeft,
//                   colors: [Colors.white.withOpacity(0), Colors.white],
//                 ),
//               ),
//               child: Center(
//                 child: _NavigationButton(
//                   icon: Icons.chevron_right,
//                   onPressed: _scrollRight,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildAllCategoryItem(CategoryController controller) {
//     return _buildCategoryItem(
//       context: context,
//       title: 'All',
//       icon: Icons.apps,
//       isSelected: controller.selectedCategory == null,
//       // onTap: () {
//       //   controller.clearSelection();
//       //   widget.onCategorySelected?.call(CategoryModel.all());
//       // },
//     );
//   }
//
//   Widget _buildCategoryItem({
//     required BuildContext context,
//     CategoryModel? category,
//     String? title,
//     String? imageUrl,
//     IconData? icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     final displayTitle = title ?? category?.name ?? '';
//     final displayImageUrl = imageUrl ?? category?.imageFullUrl;
//     final displayIcon = icon ?? _getCategoryIcon(displayTitle);
//
//     return Container(
//       width: 70,
//       margin: const EdgeInsets.only(right: 12),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(12),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: isSelected
//                         ? const Color(0xFF2563EB)
//                         : Colors.transparent,
//                     width: 2,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: isSelected
//                           ? const Color(0xFF2563EB).withOpacity(0.2)
//                           : Colors.black.withOpacity(0.06),
//                       blurRadius: isSelected ? 8 : 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: displayImageUrl != null && displayImageUrl.isNotEmpty
//                       ? CachedNetworkImage(
//                           imageUrl: displayImageUrl,
//                           fit: BoxFit.cover,
//                           placeholder: (context, url) => Container(
//                             color: const Color(0xFFF8FAFC),
//                             child: Icon(
//                               displayIcon,
//                               color: const Color(0xFF94A3B8),
//                               size: 20,
//                             ),
//                           ),
//                           errorWidget: (context, url, error) => Container(
//                             color: const Color(0xFFF8FAFC),
//                             child: Icon(
//                               displayIcon,
//                               color: const Color(0xFF94A3B8),
//                               size: 20,
//                             ),
//                           ),
//                         )
//                       : Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               colors: isSelected
//                                   ? [
//                                       const Color(0xFF2563EB),
//                                       const Color(0xFF1D4ED8),
//                                     ]
//                                   : [
//                                       const Color(0xFFF8FAFC),
//                                       const Color(0xFFE2E8F0),
//                                     ],
//                             ),
//                           ),
//                           child: Icon(
//                             displayIcon,
//                             color: isSelected
//                                 ? Colors.white
//                                 : const Color(0xFF64748B),
//                             size: 20,
//                           ),
//                         ),
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               Flexible(
//                 child: Text(
//                   displayTitle,
//                   style: TextStyle(
//                     fontSize: 11,
//                     fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                     color: isSelected
//                         ? const Color(0xFF2563EB)
//                         : const Color(0xFF374151),
//                   ),
//                   textAlign: TextAlign.center,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   IconData _getCategoryIcon(String categoryName) {
//     final name = categoryName.toLowerCase();
//
//     if (name.contains('coffee')) return Icons.coffee;
//     if (name.contains('drink') || name.contains('beverage'))
//       return Icons.local_drink;
//     if (name.contains('fast') || name.contains('burger')) return Icons.fastfood;
//     if (name.contains('cake') || name.contains('dessert')) return Icons.cake;
//     if (name.contains('sushi') || name.contains('fish')) return Icons.set_meal;
//     if (name.contains('pizza')) return Icons.local_pizza;
//     if (name.contains('ice') || name.contains('cream')) return Icons.icecream;
//     if (name.contains('salad')) return Icons.eco;
//     if (name.contains('meat')) return Icons.restaurant;
//     if (name.contains('bread') || name.contains('bakery'))
//       return Icons.bakery_dining;
//
//     return Icons.restaurant_menu;
//   }
//
//   void _navigateToViewAll(BuildContext context) {
//     // Implement navigation to view all categories page
//     // Example: context.goNamed(Screens.categoryViewAllScreen.name);
//   }
// }
//
// class _NavigationButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onPressed;
//
//   const _NavigationButton({required this.icon, required this.onPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 28,
//       height: 28,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onPressed,
//           borderRadius: BorderRadius.circular(14),
//           child: Icon(icon, color: const Color(0xFF374151), size: 18),
//         ),
//       ),
//     );
//   }
// }
