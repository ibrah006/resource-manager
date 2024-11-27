import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:resource_manager/data_provider.dart';
import 'package:resource_manager/entry.dart';
import 'package:resource_manager/entry_tile.dart';
import 'package:resource_manager/home_screen_header.dart';
import 'package:resource_manager/item.dart';
import 'package:resource_manager/no_entries_placeholder.dart';
import 'package:resource_manager/no_expenses_placeholder_screen.dart';
import 'package:resource_manager/stats_page.dart';
import 'package:http/http.dart'as http;
import 'package:provider/provider.dart';

class FinanceHomeScreen extends StatefulWidget {
  const FinanceHomeScreen({Key? key}) : super(key: key);

  @override
  State<FinanceHomeScreen> createState() => _FinanceHomeScreenState();
}

class _FinanceHomeScreenState extends State<FinanceHomeScreen> with SingleTickerProviderStateMixin {

  // List<Entry> entries = [];

  // List<Item> items = [];

  double spent =  0, sold = 0;

  late TabController _tabController;

  onGotoAddEntryScreenRequest() async {
    // move to entry screen
    await Navigator.pushNamed(context, "/add");

    // if (newEntry != null) {
    //   setState(() {
    //     // if (!products.keys.contains(newEntry.itemId)) products[newEntry.itemId] = newEntry.name;
    //     // if the item doesn't exist then create
    //     int targetItemindex = items.indexWhere((item)=> item.itemId == newEntry.itemId);
    //     if (targetItemindex == -1) {
    //       items.add(
    //         Item(newEntry.itemId, name: newEntry.name, quantityBought: 0, quantitySold: 0, totalBought: 0, totalSold: 0)
    //       );
    //       targetItemindex = items.length - 1;
    //     } 
        
    //     if (newEntry.isSell) {
    //       items[targetItemindex].quantitySold += newEntry.quantity;
    //       items[targetItemindex].totalSold += newEntry.price;
    //     } else {
    //       items[targetItemindex].quantityBought += newEntry.quantity;
    //       items[targetItemindex].totalBought += newEntry.price;
    //     }

    //     entries.add(newEntry);
    //     calculateHeader(newEntry: newEntry);
    //   });
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Successfully added entry'),
    //     ),
    //   );
    // }
  }

  getEntries() => Provider.of<DataProvider>(context, listen: false).entries;
  getItems()=> Provider.of<DataProvider>(context, listen: false).items;

  gotoExpensesScreen() async {

    final expesnes = getEntries().where((entry)=> !entry.isSell);

    if (expesnes.isEmpty) {
      await showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return NoExpensesPlaceholderScreen();
        }
      );
      return;
    }

    Navigator.pushNamed(context, "/expenses");
  }

  gotoSettingsScreen()=> Navigator.pushNamed(context, "/settings");

  @override
  Widget build(BuildContext context) {

    // print([items.firstWhere((item)=> item.name == "Apple").quantitySold, items.firstWhere((item)=> item.name == "Apple").quantityBought]);

    return Consumer<DataProvider>(
      builder: (context, dataNotifier, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A2E), // Dark background
          appBar: AppBar(
            backgroundColor: const Color(0xFF1A1A2E),
            elevation: 0,
            leading: const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(Icons.person, size: 27, color: Colors.white),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 20, top: 10),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.settings, color: Colors.black),
                    onPressed: gotoSettingsScreen,
                  ),
                ),
              ),
            ],
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            bottom: TabBar(
              dividerColor: Color.fromARGB(255, 35, 35, 70),
              controller: _tabController,
              indicatorColor: const Color(0xFF4D4DFF), // Accent color for selected tab
              labelColor: const Color(0xFF4D4DFF),
              unselectedLabelColor: Colors.white38,
              tabs: const [
                Tab(text: "Home",),
                Tab(text: "Statistics"),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                    
                          // Total Balance Section
                          HomeScreenHeader(totalBalance: (sold - spent), totalIncome: sold, totalSpending: spent),
                          const SizedBox(height: 20),
                    
                    
                          // Transactions Section
                          const Text(
                            "Transactions",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ... getEntries().isNotEmpty? List.generate(
                            getEntries().length,
                            (index) {
                    
                              final entry = getEntries().reversed.elementAt(index);
                    
                              return EntryTile(entry);
                            }
                          ) : [
                            NoEntriesPlaceholder()
                          ]
                        ],
                      ),
                    ),
                    StatisticsPage()
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFF222244),
            onPressed: onGotoAddEntryScreenRequest,
            child: Icon(Icons.add, color: Colors.white)
          ),
        );
      }
    );
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

    getItems().forEach((item) {
      update(item);
    });
  }

  @override
  void initState() {
    super.initState();

    // getSubcategories("Techonology");

    Provider.of<DataProvider>(context, listen: false).entries;

    _tabController = TabController(length: 2, vsync: this);

    _getsamples();

    Future.delayed(Duration(milliseconds: 100)).then((value) {
      print("items: ${getItems()}, entries, ${getEntries()}");
      calculateHeader();
      setState(() {
        
      });
    });

  }

  Future<void> getSubcategories(String category) async {
    final String endpoint = 'https://dbpedia.org/sparql';
    final String query = '''
    SELECT ?subcategory WHERE {
      ?subcategory <http://www.w3.org/2004/02/skos/core#broader> <http://dbpedia.org/resource/Category:$category> .
    }
    LIMIT 10
    ''';

    final response = await http.get(
      Uri.parse('$endpoint?query=${Uri.encodeComponent(query)}&format=json'),
      headers: {
        'Accept': 'application/sparql-results+json',  // Updated Accept header
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var subcategoryList = data['results']['bindings'];

      print("subcategories: ${subcategoryList}");

      List<String> subcategories = subcategoryList.map<String>((item) {
        return item['subcategory']['value'];
      }).toList();

      print('Subcategories: $subcategories');
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
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

      Provider.of<DataProvider>(context, listen: false).items.add(Item(itemId, name: name, quantityBought: quantityBought, quantitySold: quantitySold, totalBought: totalBought, totalSold: totalSold));
    }

    // Creating a Map for easy lookup of product names by itemId
    Map<String, String> productIdToName = {
      for (var item in getItems()) item.itemId: item.name
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
      Provider.of<DataProvider>(context, listen: false).entries.add(Entry(
        itemId, 
        entryId: entryId,
        dateTime: dateTime, 
        price: amount, 
        isSell: isSell, 
        category: category, 
        quantity: quantity, 
        name: name
      ));
    }
  }

}
