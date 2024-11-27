import 'package:resource_manager/database.dart';
import 'package:sqflite/sqflite.dart';

class Item {

  Item(this.itemId, {required this.name, required this.quantityBought, required this.quantitySold, required this.totalBought, required this.totalSold});

  String name;

  double totalBought, totalSold;
  int quantityBought, quantitySold;

  String itemId;

  int netQuantity()=> quantityBought - quantitySold;

  double netValue()=> totalSold - totalBought;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json["itemId"], name: json["name"], quantityBought: json["quantityBought"], quantitySold: json["quantitySold"], totalBought: json["totalBought"], totalSold: json["totalSold"]);
  }

  Map<String, Object?> toMap() {
    return {
      "itemId": itemId,
      "name": name,
      "totalBought": totalBought,
      "totalSold": totalSold,
      "quantityBought": quantityBought,
      "quantitySold": quantitySold,
    };
  }

  double getItemPrice({required bool isSell}) {
    return isSell? totalSold/quantitySold : totalBought/quantityBought;
  }

  int getItemQuantity({required bool isSell}) {
    return isSell? quantitySold : quantityBought;
  }

  static const TABLENAME = "entries";

  Future<bool> _isItemExist(String itemId) async {
    Database db = await LocalDatabase.database;
    var result = await db.query(
      TABLENAME,
      where: 'itemId = ?',
      whereArgs: [itemId],
    );
    return result.isNotEmpty;
  }

  Future<int> addItem() async {
    Database db = await LocalDatabase.database;
    
    // Check if item already exists based on itemId
    bool exists = await _isItemExist(itemId);
    if (exists) {
      // Return a message or perform another action if item already exists
      print("Item with itemId ${itemId} already exists.");
      return -1;
    }

    // Proceed to insert if no duplicate
    return await db.insert(TABLENAME, toMap());
  }

  // Update an existing item
  Future<int> updateItem(Item) async {
    Database db = await LocalDatabase.database;
    return await db.update(
      TABLENAME,
      toMap(),
      where: 'itemId = ?',
      whereArgs: [itemId],
    );
  }

}