
import 'package:resource_manager/database.dart';
import 'package:resource_manager/item.dart';
import 'package:sqflite/sqflite.dart';

class Entry {
  Entry(
    this.itemId, {
      required entryId,
      required this.dateTime,
      required this.price,
      required this.isSell,
      required String category,
      required this.quantity,
      required this.name}) {
    if (category.trim().isNotEmpty) {
      this.category = category;
    }

    if (entryId != null) {
      this.entryId = entryId;
    }
  }

  //  Item toItem() {
  //     return Item(itemId, name: name, quantity:  quantity, value: value, quantitySold: quantitySold);
  //   }

  String itemId, name;
  late String entryId;

  int quantity;
  
  DateTime dateTime;
  double price;

  bool isSell;

  String? category;

  static const String TABLENAME = "entries";

  factory Entry.fromItem(Item item, bool isSell) {
    return Entry(item.itemId, entryId: null, dateTime: DateTime.now(), price: item.getItemPrice(isSell: isSell), isSell: isSell, category: "", quantity: item.getItemQuantity(isSell: isSell), name: item.name);
  }

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(json["itemId"], entryId: json["entryId"], dateTime: DateTime.fromMillisecondsSinceEpoch(json["dateTime"]), price: json["price"], isSell: json["isSell"]==1, category: json["category"]?? "", quantity: json["quantity"], name: json["name"]);
  }

  Map<String, Object?> toMap() {
    return {
      "itemId": itemId,
      "entryId": entryId,
      "name": name,
      "quantity": quantity,
      "dateTime": dateTime.millisecondsSinceEpoch,
      "price": price,
      "isSell": isSell? 1 : 0,
      "category": category
    };
  }


  /// adds this entry to the database if it doesn't exist alreadt
  Future<int> addEntry() async {
    Database db = await LocalDatabase.database;
    
    // add to entries table
    final result = await db.insert(TABLENAME, toMap());
    return result;
  }

  Future<bool> _isItemExist() async {
    Database db = await LocalDatabase.database;
    late final List<Map<String, Object?>> result;
    try {
      result = await db.query(
        TABLENAME,
        where: 'itemId = ?',
        whereArgs: [itemId],
      );
    } catch(e) {
      result = [];
    }
    return result.isNotEmpty;
  }
  
  // Future<int> addItem() async {
  //   Database db = await LocalDatabase.database;
    
  //   // Check if item already exists based on itemId
  //   bool exists = await _isItemExist();
  //   if (exists) {
  //     // Return a message or perform another action if item already exists
  //     print("Item with itemId ${itemId} already exists.");
  //     return -1;
  //   }

  //   // Proceed to insert if no duplicate
  //   return await db.insert(Item.TABLENAME, Item(itemId, name: name, quantityBought: 0, quantitySold: 0, totalBought: 0, totalSold: 0).toMap());
  // }


  // Update an existing entry
  Future<int> updateEntry() async {
    Database db = await LocalDatabase.database;
    return await db.update(
      TABLENAME,
      toMap(),
      where: 'entryId = ?',
      whereArgs: [entryId],
    );
  }
}