

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:resource_manager/item.dart';
import 'package:resource_manager/entry.dart';

class DataProvider extends ChangeNotifier {

  List<Entry> entries = [];
  List<Item> items = [];

  addEntry(BuildContext context, {required Entry? newEntry}) {
    if (newEntry != null) {

      // if (!products.keys.contains(newEntry.itemId)) products[newEntry.itemId] = newEntry.name;
      // if the item doesn't exist then create
      int targetItemindex = items.indexWhere((item)=> item.itemId == newEntry.itemId);
      if (targetItemindex == -1) {
        items.add(
          Item(newEntry.itemId, name: newEntry.name, quantityBought: 0, quantitySold: 0, totalBought: 0, totalSold: 0)
        );
        targetItemindex = items.length - 1;
      } 
      
      if (newEntry.isSell) {
        items[targetItemindex].quantitySold += newEntry.quantity;
        items[targetItemindex].totalSold += newEntry.price;
      } else {
        items[targetItemindex].quantityBought += newEntry.quantity;
        items[targetItemindex].totalBought += newEntry.price;
      }

      entries.add(newEntry);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully added entry'),
        ),
      );

      notifyListeners();
    }
  }

}