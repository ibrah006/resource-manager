import 'package:flutter/material.dart';
import 'package:resource_manager/entry.dart';
import 'package:resource_manager/entry_tile.dart';

class TransactionTile extends StatelessWidget {
  final Entry entry;

  const TransactionTile(this.entry);

  String get categoryName=> entry.category?? "Uncategorized";
  IconData get categoryIcon => Icons.category_rounded;
  String get dateTime => EntryTile.formatDateTime(entry.dateTime);
  double get amount => entry.price;
  bool get isIncome => entry.isSell;
  int get quantity => entry.quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF222244),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon and Details
          Row(
            children: [
              // Icon
              CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.white.withOpacity(0.1),
                child: Icon(
                  categoryIcon,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 12.0),

              // Category and Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Qty: $quantity • $dateTime",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Amount
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: isIncome ? Colors.greenAccent : Colors.redAccent,
              fontSize: 16.0,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}
