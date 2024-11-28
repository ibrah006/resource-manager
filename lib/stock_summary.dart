import 'package:flutter/material.dart';
import 'package:resource_manager/entry.dart';
import 'package:resource_manager/item.dart';

class StockSummary extends StatelessWidget {
  final Item item;

  const StockSummary(this.item, {Key? key}) : super(key: key);

  String get itemName => item.name;
  int get quantity => item.netQuantity();
  double get costPrice => item.totalBought / item.quantityBought;
  double get sellingPrice => item.totalSold / item.quantitySold;
  double get totalProfit => item.netValue();
  List<String> get topBuyers => [];
  double get avgSellingTime => 23;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF222244),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              // Item Image/Icon
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.inventory, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),

              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "In Stock: ${quantity > 0 ? '$quantity Units' : 'Out of Stock'}",
                      style: TextStyle(
                        fontSize: 14,
                        color: quantity > 0
                            ? Colors.white.withOpacity(0.7)
                            : const Color(0xFFFF6D34),
                      ),
                    ),
                  ],
                ),
              ),

              // Action Menu
              Icon(Icons.more_vert, color: Colors.white.withOpacity(0.8)),
            ],
          ),
          const SizedBox(height: 16),

          // Metrics Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricTile(
                title: "Cost Price",
                value: "\$${costPrice.toStringAsFixed(2)}",
              ),
              _buildMetricTile(
                title: "Selling Price",
                value: "\$${sellingPrice.toStringAsFixed(2)}",
              ),
              _buildMetricTile(
                title: "Profit",
                value: totalProfit >= 0
                    ? "\$${totalProfit.toStringAsFixed(2)}"
                    : "-\$${(totalProfit * -1).toStringAsFixed(2)}",
                valueColor: totalProfit >= 0
                    ? Colors.green
                    : const Color(0xFFFF6D34),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Insights Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Avg Selling Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Avg Selling Time",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$avgSellingTime days",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Top Buyers
              Row(
                children: [
                  const Text(
                    "Top Buyers",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  ...topBuyers.take(3).map(
                        (buyer) => Container(
                          margin: const EdgeInsets.only(left: 8),
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: Center(
                            child: Text(
                              buyer[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                context,
                label: "Add",
                icon: Icons.add,
                color: Colors.green,
                onTap: () => Navigator.pushNamed(
                  context,
                  '/add',
                  arguments: Entry.fromItem(item, false),
                ),
              ),
              _buildActionButton(
                context,
                label: "Out",
                icon: Icons.remove,
                color: const Color(0xFFFF6D34),
                onTap: () => Navigator.pushNamed(
                  context,
                  '/add',
                  arguments: Entry.fromItem(item, true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: valueColor ?? Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: color),
      label: Text(label, style: TextStyle(color: color)),
      style: TextButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
