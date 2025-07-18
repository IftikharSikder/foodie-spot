import 'package:flutter/material.dart';

import '../screen/search_screen.dart';

class SearchWidgets extends StatelessWidget {
  const SearchWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
          );
        },
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: const Row(
              children: [
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    'Search food or restaurant here...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.search, color: Colors.grey, size: 22),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
