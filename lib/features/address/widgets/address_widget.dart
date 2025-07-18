import 'package:flutter/material.dart';

class AddressWidget extends StatelessWidget {
  const AddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        children: [
          Icon(Icons.home, color: Colors.grey[600], size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '76A eighth avenue, New York, US',
                  style: TextStyle(fontSize: 14, color: Color(0xFFc2c2c2)),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Icon(Icons.notifications, size: 28, color: Colors.black),

              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
