

import 'package:flutter/material.dart';
import 'package:resource_manager/entry.dart';
import 'package:intl/intl.dart';

class EntryTile extends StatelessWidget {
  const EntryTile(this.entry, {super.key});

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF222244),
        child: const Icon(Icons.shopping_bag, color: Colors.white),
      ),
      title: Text(
        entry.name,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        formatDateTime(entry.dateTime),
        style: TextStyle(color: Colors.white54),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            //${entry.isSell? '+' : '-'}
            "\$${(entry.price * entry.quantity).toStringAsFixed(2)}",
            style: TextStyle(
              color: entry.isSell? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 13.5
            ),
          ),
          SizedBox(height: 1.5),
          Text(
            "Qty: ${entry.quantity.toString()}",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 11
            )
          )
        ],
      ),
    );
  }

  static String formatDateTime(DateTime dateTime) {
    final today = DateTime.now();
    
    // Check if the given date is today
    if (dateTime.year == today.year && dateTime.month == today.month && dateTime.day == today.day) {
      // If today, return 'Today, hh:mm'
      return "Today, ${DateFormat("hh:mm a").format(dateTime)}";
    } else {
      // Otherwise, return 'MM dd, hh:mm'
      return DateFormat("MM/dd, hh:mm a").format(dateTime);
    }
  } 
}