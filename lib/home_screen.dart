import 'dart:convert';

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
import 'package:resource_manager/transaction_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class FinanceHomeScreen extends StatefulWidget {
  const FinanceHomeScreen({Key? key}) : super(key: key);

  @override
  State<FinanceHomeScreen> createState() => _FinanceHomeScreenState();
}

class _FinanceHomeScreenState extends State<FinanceHomeScreen> with SingleTickerProviderStateMixin {

  // List<Entry> entries = [];

  // List<Item> items = [];

  late TabController _tabController;

  late final SharedPreferences sharedPreferences;

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
                    icon: const Icon(Icons.settings, color: Color(0xFF1A1A2E)),
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
                          HomeScreenHeader(totalBalance: (dataNotifier.sold - dataNotifier.spent), totalIncome: dataNotifier.sold, totalSpending: dataNotifier.spent),
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
                    
                              return TransactionTile(entry);
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


  @override
  void initState() {
    super.initState();

    // getSubcategories("Techonology");

    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
      Provider.of<DataProvider>(context, listen: false).initalizeIsSample(initialValue: sharedPreferences.getBool("isSampleLoaded") == true);
      setState(() {});
    });

    _tabController = TabController(length: 2, vsync: this);

    Future.delayed(Duration(milliseconds: 100)).then((value) {
      print("items: ${getItems()}, entries, ${getEntries()}");
      Provider.of<DataProvider>(context, listen: false).calculateHeader();
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

}
