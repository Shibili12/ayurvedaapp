import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final String message;
  const EmptyListWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image.asset(
          //   "assets/images/empty.png", // Add this image to assets
          //   width: 180,
          // ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
