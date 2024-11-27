import 'package:flutter/material.dart';

class EmptyItemsPlaceholder extends StatelessWidget {
  final VoidCallback? onAddItemPressed;

  const EmptyItemsPlaceholder({Key? key, this.onAddItemPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Centered Content for Empty State
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration/Icon
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF3A3A50), // Subtle background color
                ),
                child: Icon(
                  Icons.store_mall_directory_outlined,
                  size: 80,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                "No items found",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle/Description
              Text(
                "You haven't added any items yet.\nStart adding items to track your inventory.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Add Item Button (Optional)
              if (onAddItemPressed != null)
                ElevatedButton.icon(
                  onPressed: onAddItemPressed,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Item"),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Floating Add Button (Optional)
        if (onAddItemPressed != null)
          Positioned(
            bottom: 30,
            right: 30,
            child: FloatingActionButton(
              onPressed: onAddItemPressed,
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
