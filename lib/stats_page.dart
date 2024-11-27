import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resource_manager/data_provider.dart';
import 'package:resource_manager/empty_item_placeholder.dart';
import 'package:resource_manager/stock_summary.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final items = Provider.of<DataProvider>(context, listen: false).items;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Item Statistics",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          items.isEmpty? EmptyItemsPlaceholder() : Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return StockSummary(item);
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF222244),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem(
                            label: "Quantity bought",
                            value: item.quantityBought.toString(),
                          ),
                          _buildStatItem(
                            label: "Total Cost",
                            value: "\$${item.totalBought.toStringAsFixed(2)}",
                          ),
                          _buildStatItem(
                            label: "Total Sold",
                            value: "\$${item.totalSold.toStringAsFixed(2)}",
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem(
                            label: "Net Balance",
                            value: "\$${item.netValue().toStringAsFixed(2)}",
                          ),
                          _buildStatItem(
                            label: "Net Quantity",
                            value: item.netQuantity().toString(),
                            highlight: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({required String label, required String value, bool highlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: highlight ? const Color(0xFF4CAF50) : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}