import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WebHeaderWidget extends StatefulWidget {
  const WebHeaderWidget({super.key});
  @override
  State<WebHeaderWidget> createState() => _WebHeaderWidgetState();
}

class _WebHeaderWidgetState extends State<WebHeaderWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;
  bool _isNotificationHovered = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: [
            Expanded(flex: 3, child: _buildDeliveryAddress()),
            const SizedBox(width: 32),
            Expanded(flex: 4, child: _buildSearchBar()),
            const SizedBox(width: 32),
            Expanded(flex: 1, child: _buildNotificationSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFF4444),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.location_on_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Delivery Address',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '123 Main Street, New York',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: const Color(0xFF6B7280),
          size: 20,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isSearchFocused
              ? const Color(0xFFFF4444)
              : const Color(0xFFE5E7EB),
          width: _isSearchFocused ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            Icons.search_rounded,
            color: _isSearchFocused
                ? const Color(0xFFFF4444)
                : const Color(0xFF9CA3AF),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _isSearchFocused = hasFocus;
                });
              },
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for restaurants, cuisines or dishes',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF9CA3AF),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isNotificationHovered = true),
          onExit: (_) => setState(() => _isNotificationHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _isNotificationHovered
                  ? const Color(0xFFF3F4F6)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications_outlined,
                    size: 24,
                    color: Color(0xFF374151),
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WebHeaderDemo extends StatelessWidget {
  const WebHeaderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const WebHeaderWidget(),

          Expanded(
            child: Container(
              color: const Color(0xFFF9FAFB),
              child: const Center(
                child: Text(
                  'Page Content Here',
                  style: TextStyle(fontSize: 24, color: Color(0xFF6B7280)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
