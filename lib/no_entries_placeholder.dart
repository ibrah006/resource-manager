import 'package:flutter/material.dart';

class NoEntriesPlaceholder extends StatelessWidget {

  const NoEntriesPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Centered Empty State Content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon or Illustration
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF3A3A50), // Subtle background color for the icon
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 80,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 20),

              // Friendly Message
              Text(
                "No entries here yet",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Start adding your items to see the summary.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
