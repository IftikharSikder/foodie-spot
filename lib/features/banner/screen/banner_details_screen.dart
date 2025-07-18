import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/models/banner_model.dart';

class BannerDetailScreen extends StatelessWidget {
  final BannerModel banner;

  const BannerDetailScreen({Key? key, required this.banner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          banner.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image
            _buildBannerImage(context),

            const SizedBox(height: 16),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),

                  const SizedBox(height: 16),

                  _buildDescriptionSection(),

                  const SizedBox(height: 24),

                  _buildDetailsSection(),

                  const SizedBox(height: 24),

                  _buildActionButton(context),

                  const SizedBox(height: 24),

                  _buildAdditionalInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerImage(BuildContext context) {
    String imageUrl = banner.imageFullUrl;
    if (imageUrl.isEmpty && banner.image != null && banner.image!.isNotEmpty) {
      imageUrl =
          'https://stackfood-admin.6amtech.com/storage/app/public/banner/${banner.image}';
    }

    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  print(
                    'Banner detail image load error: $error for URL: $imageUrl',
                  );
                  return Container(
                    color: Colors.grey[300],
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Image not available',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Container(
                color: Colors.grey[300],
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'No image available',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                banner.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Banner ID: ${banner.id}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: banner.isActive ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            banner.isActive ? 'Active' : 'Inactive',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    String description = '';
    if (banner.restaurant != null) {
      description =
          'Restaurant: ${banner.restaurant!.name}\nAddress: ${banner.restaurant!.address}';
    } else if (banner.food != null) {
      description =
          'Food: ${banner.food!.name}\nDescription: ${banner.food!.description ?? 'No description available'}';
    } else {
      description = banner.description.isNotEmpty
          ? banner.description
          : 'No description available';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: description.isNotEmpty ? Colors.black87 : Colors.grey[500],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            _buildDetailCard('Type', banner.type, Icons.category),
            if (banner.restaurant != null) ...[
              _buildDetailCard(
                'Restaurant',
                banner.restaurant!.name,
                Icons.store,
              ),
              _buildDetailCard('Phone', banner.restaurant!.phone, Icons.phone),
              _buildDetailCard('Email', banner.restaurant!.email, Icons.email),
              if (banner.restaurant!.deliveryTime != null)
                _buildDetailCard(
                  'Delivery Time',
                  banner.restaurant!.deliveryTime!,
                  Icons.access_time,
                ),
            ],
            if (banner.food != null) ...[
              _buildDetailCard(
                'Food',
                banner.food!.name,
                Icons.restaurant_menu,
              ),
              _buildDetailCard(
                'Price',
                '\${banner.food!.price.toStringAsFixed(2)}',
                Icons.attach_money,
              ),
            ],
            if (banner.redirectUrl != null)
              _buildDetailCard('Redirect URL', banner.redirectUrl!, Icons.link),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleAction(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getActionIcon()),
            const SizedBox(width: 8),
            Text(
              _getActionText(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          if (banner.createdAt != null)
            _buildInfoRow('Created', _formatDate(banner.createdAt!)),
          if (banner.updatedAt != null)
            _buildInfoRow('Updated', _formatDate(banner.updatedAt!)),
          _buildInfoRow('Image', banner.image),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  IconData _getActionIcon() {
    switch (banner.type) {
      case 'restaurant_wise':
        return Icons.store;
      case 'food_wise':
        return Icons.restaurant_menu;
      case 'default':
        return Icons.info;
      default:
        return Icons.touch_app;
    }
  }

  String _getActionText() {
    switch (banner.type) {
      case 'restaurant_wise':
        return 'View Restaurant';
      case 'food_wise':
        return 'View Food Details';
      case 'default':
        return 'View Details';
      default:
        return 'Take Action';
    }
  }

  void _handleAction(BuildContext context) {
    switch (banner.type) {
      case 'restaurant_wise':
        if (banner.restaurant != null) {
          _showSnackBar(
            context,
            'Navigate to restaurant: ${banner.restaurant!.name}',
          );
        }
        break;
      case 'food_wise':
        if (banner.food != null) {
          _showSnackBar(context, 'Navigate to food: ${banner.food!.name}');
        }
        break;
      case 'default':
        if (banner.redirectUrl != null) {
          _launchUrl(banner.redirectUrl!);
        } else {
          _showSnackBar(context, 'Banner details viewed');
        }
        break;
      default:
        _showSnackBar(context, 'Banner action triggered');
        break;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }
}
