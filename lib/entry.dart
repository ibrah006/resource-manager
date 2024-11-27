
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
  //     return Item(itemId, name: name, quantity: quantity, value: value, quantitySold: quantitySold);
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
    return Entry(json["itemId"], entryId: json["entryId"], dateTime: json["dateTime"], price: json["price"], isSell: json["isSell"]==1, category: json["category"], quantity: json["quantity"], name: json["name"]);
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
    final result = await db.insert(TABLENAME, toMap());
    return result;
  }

  Future<bool> _isItemExist(String entryId) async {
    Database db = await LocalDatabase.database;
    var result = await db.query(
      TABLENAME,
      where: 'entryId = ?',
      whereArgs: [entryId],
    );
    return result.isNotEmpty;
  }

  Future<int> addItem() async {
    Database db = await LocalDatabase.database;
    
    // Check if item already exists based on itemId
    bool exists = await _isItemExist(entryId);
    if (exists) {
      // Return a message or perform another action if item already exists
      print("Item with itemId ${entryId} already exists.");
      return -1;
    }

    // Proceed to insert if no duplicate
    return await db.insert(TABLENAME, toMap());
  }


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