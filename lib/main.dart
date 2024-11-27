
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resource_manager/add_screen.dart';
import 'package:resource_manager/animated_circular_indiactors.dart';
import 'package:resource_manager/concepts.dart';
import 'package:resource_manager/data_provider.dart';
import 'package:resource_manager/home_screen.dart';
import 'package:resource_manager/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  runApp(ResourceManagerApp());
}

class ResourceManagerApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> DataProvider())
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'Resource Manager',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          // home: FinanceHomeScreen(),//TabbedHomeScreen(),
          initialRoute: "/",
          routes: {
            "/": (context)=> FinanceHomeScreen(),
            "/add": (context)=> AddEntryScreen(),
            "/expenses": (context)=> ExpensesScreen(),
            '/settings': (context)=> SettingsScreen()
          }
        );
      }
    );
  }
}

class HomeScreen extends StatelessWidget {
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ModalBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animation Inside Modal BottomSheet')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showBottomSheet(context),
          child: Text('Open Modal BottomSheet'),
        ),
      ),
    );
  }
}

class ModalBottomSheet extends StatefulWidget {
  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet> with SingleTickerProviderStateMixin {
  // Animation controller
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  // Initialize the animation controller and animation
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this, // Pass `this` to indicate that the current state class provides the ticker
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(seconds: 1)).then((v) {
      _toggleAnimation();
    });
  }

  // Dispose the controller when done
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to trigger the animation
  void _toggleAnimation() {
    if (_controller.isCompleted) {
      _controller.reverse(); // Reverse the animation if completed
    } else {
      _controller.forward(); // Forward the animation if not completed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedCircularIndiactors.sample(),
          FadeTransition(
            opacity: _opacityAnimation, // Apply the opacity animation here
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
              child: Center(child: Text('Fade Me', style: TextStyle(color: Colors.white))),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _toggleAnimation, // Button to toggle animation
            child: Text('Toggle Fade Animation'),
          ),
        ],
      ),
    );
  }
}

// ItemSummaryPage(
//       itemName: 'Wireless Headphones',
//       quantityInStock: 150,
//       costPrice: 35.00,
//       sellingPrice: 79.99,
//       unitsSold: 120,
//       totalProfit: 4800.00,
//       lastRestockedDate: DateTime(2024, 10, 15),
//       itemCategory: 'Electronics',
//       supplier: 'TechSuppliers Inc.',
//       itemDescription: 'High-quality wireless headphones with noise-cancelling features.',
//     )

// ItemSummaryPage(itemName: "Item Name", quantityInStock: 132, costPrice: 233.59, sellingPrice: 567, unitsSold: 223, totalProfit: 423, lastRestockedDate: DateTime.now(), itemCategory: "category", supplier: "Supplier/Payee", itemDescription: "this is a sample desciprtion of the item")


// class ItemSummaryPage extends StatelessWidget {
//   final String itemName;
//   final int quantityInStock;
//   final double costPrice;
//   final double sellingPrice;
//   final int unitsSold;
//   final double totalProfit;
//   final DateTime lastRestockedDate;
//   final String itemCategory;
//   final String supplier;
//   final String itemDescription;

//   ItemSummaryPage({
//     required this.itemName,
//     required this.quantityInStock,
//     required this.costPrice,
//     required this.sellingPrice,
//     required this.unitsSold,
//     required this.totalProfit,
//     required this.lastRestockedDate,
//     required this.itemCategory,
//     required this.supplier,
//     required this.itemDescription,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Item Summary - $itemName'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Item Name and Category
//             Text(
//               itemName,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Category: $itemCategory',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
//             SizedBox(height: 16),

//             // Item Quantity and Profit
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildStat('In Stock', '$quantityInStock units'),
//                 _buildStat('Sold', '$unitsSold units'),
//                 _buildStat('Total Profit', '\$$totalProfit'),
//               ],
//             ),
//             SizedBox(height: 16),

//             // Cost and Selling Price
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildStat('Cost Price', '\$$costPrice'),
//                 _buildStat('Selling Price', '\$$sellingPrice'),
//               ],
//             ),
//             SizedBox(height: 16),

//             // Financial Summary Section
//             Text(
//               'Financial Summary',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildStat('Total Revenue', '\$${unitsSold * sellingPrice}'),
//                 _buildStat('Total Cost', '\$${unitsSold * costPrice}'),
//                 _buildStat('Net Profit', '\$${totalProfit}'),
//               ],
//             ),
//             SizedBox(height: 16),

//             // Restocking and Supplier Info
//             Text(
//               'Supplier: $supplier',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Last Restocked: ${lastRestockedDate.toLocal().toString().split(' ')[0]}',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 16),

//             // Item Description
//             Text(
//               'Description:',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               itemDescription,
//               style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStat(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//         ),
//         SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }