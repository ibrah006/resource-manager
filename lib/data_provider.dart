

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:resource_manager/item.dart';
import 'package:resource_manager/entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider extends ChangeNotifier {

  List<Entry> entries = [];
  List<Item> items = [];

  double spent =  0, sold = 0;

  bool _isSampleLoaded = false;
  bool sampleLoaded = false;

  late final SharedPreferences _prefs;

  bool isSampleLoaded()=> _isSampleLoaded;
  
  void initalizeIsSample({required bool initialValue}) {
    _isSampleLoaded = initialValue;
    sampleLoaded = initialValue;
    if (initialValue) {
      _getsamples();
    }
  }

  void toggleIsSample({bool? value}) async {

    try {
      _prefs;
    } catch(e) {
      _prefs = await SharedPreferences.getInstance();
    }

    final newValue = value?? !_isSampleLoaded;
    if (newValue != _isSampleLoaded) {
      _isSampleLoaded = newValue;
      if (newValue) {
        sampleLoaded = true;
        _getsamples();
      }

      notifyListeners();

      await _prefs.setBool("isSampleLoaded", newValue);
    }
  }

  void _getsamples() {
    // List<String> itemNames = ["Fruits & Vegetables", "Snacks", "Dairy", "Frozen", "Laptop", "Accessories"];
    // List<String> categories = ["Groceries", "Garmets", "Electronics", "Subcription", "Other"];
    List<String> itemNames = ["Apple", "Banana", "Orange", "Mango", "Grape", "Pineapple", "Peach", "Plum"];
    List<String> categories = ["Fruits", "Vegetables", "Snacks", "Beverages", "Dairy", "Frozen"];
    
    // Generating random Product IDs and ensuring no duplicates in product names
    List<String> productIds = List.generate(8, (index) => 'P${(index + 1).toString().padLeft(3, '0')}');
    List<String> entryIds = List.generate(20, (index) => 'E${(index + 1).toString().padLeft(4, '1')}');
    
    // Creating a list of random Item instances
    for (int i = 0; i < itemNames.length; i++) {
      String itemId = productIds[i];
      String name = itemNames[i];
      int quantityBought = Random().nextInt(100) + 1; // Random quantity between 1 and 100\
      int quantitySold = Random().nextInt(quantityBought) + 1;
      double totalBought = (Random().nextDouble() * 5) + 1.5; // Random value between 1.5 and 6
      double totalSold = (Random().nextDouble() * 5) + 1.5;

      items.add(Item(itemId, name: name, quantityBought: quantityBought, quantitySold: quantitySold, totalBought: totalBought, totalSold: totalSold));
      // Provider.of<DataProvider>(context, listen: false).items.add();
    }

    // Creating a Map for easy lookup of product names by itemId
    Map<String, String> productIdToName = {
      for (var item in items) item.itemId: item.name
    };

     // Generating random Entry instances from the items list
    for (int i = 0; i < 20; i++) {
      // Randomly pick an existing product ID (from the items list)
      String itemId = productIds[Random().nextInt(productIds.length)];
      String entryId = entryIds[Random().nextInt(entryIds.length)];
      String name = productIdToName[itemId]!; // Get corresponding name for the itemId

      DateTime dateTime = DateTime.now().subtract(Duration(days: Random().nextInt(30))); // Random date within the last 30 days
      double amount = (Random().nextDouble() * 10) + 1.0; // Random amount between 1.0 and 11.0
      bool isSell = Random().nextBool(); // Randomly pick if it's a sale or not
      String category = categories[Random().nextInt(categories.length)]; // Random category
      int quantity = Random().nextInt(5) + 1; // Random quantity between 1 and 5

      // Create an Entry instance
      addEntry(null, newEntry: Entry(
        itemId, 
        entryId: entryId,
        dateTime: dateTime, 
        price: amount, 
        isSell: isSell, 
        category: category, 
        quantity: quantity, 
        name: name
      ));
      // Provider.of<DataProvider>(context, listen: false).entries.add();
    }
    calculateHeader();
  }

  addEntry(BuildContext? context, {required Entry? newEntry}) {
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

      context!=null?
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully added entry'),
          ),
        ) : null;

      notifyListeners();
    }
  }

  void calculateHeader({Entry? newEntry}) {

    // update(Entry entry) {
      // TODO: update the specific product
    //   if (entry.isSell) {
    //     sold += (entry.amount * entry.quantity);
        
    //   } else {
    //     spent += (entry.amount * entry.quantity);
    //   }
    // }

    // if (newEntry != null) {
    //   update(newEntry);
    //   return;
    // }

    // entries.forEach((entry) {
    //   update(entry);
    // });

    update(Item item) {
      // TODO: update the specific product
      sold += item.totalSold * item.quantitySold;
      spent += item.totalBought * item.totalBought;
    }

    if (newEntry != null) {
      if (newEntry.isSell) {
        sold += newEntry.price * newEntry.quantity;
      } else {
        spent += newEntry.price * newEntry.quantity;
      }
      return;
    }

    items.forEach((item) {
      update(item);
    });
  }

}