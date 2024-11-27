import 'package:flutter/material.dart';
import 'package:resource_manager/item.dart';
import 'package:resource_manager/entry.dart';

class StockSummary extends StatelessWidget {
  final Item item;

  const StockSummary(this.item, {
    Key? key,
  }) : super(key: key);

  String get itemName => item.name;
  // String get category => item.category?? "Uncategorised";
  // String get itemImage => item.;
  int get quantity => item.netQuantity();
  double get costPrice => item.totalBought / item.quantityBought;
  double get sellingPrice => item.totalSold / item.quantitySold;
  double get totalProfit => item.netValue();
  List<String> get topBuyers => [];
  double get avgSellingTime => 23;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF222244),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              // Item Image/Icon
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  // image: DecorationImage(
                  //   image: NetworkImage(itemImage),
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
              const SizedBox(width: 16),
              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Text(
                    //   category,
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: Colors.white.withOpacity(0.7),
                    //   ),
                    // ),
                  ],
                ),
              ),
              // Action Menu
              Icon(Icons.more_vert, color: Colors.white.withOpacity(0.8)),
            ],
          ),
          const SizedBox(height: 16),

          // Quantity and Profit Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Quantity
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Quantity in Stock",
                      style: TextStyle(
                          color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    quantity==0? "Out of Stock" : "$quantity Units",
                    style: TextStyle(
                      fontSize: 16,
                      color: quantity==0? Color(0xFFFF6D34) : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Profit
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Profit",
                      style: TextStyle(
                          color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    "\$${totalProfit.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16,
                      color: totalProfit < 0? Color(0xFFFF6D34) : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Sales and Cost Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cost Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Cost Price",
                      style: TextStyle(
                          color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    "\$${costPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Selling Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Selling Price",
                      style: TextStyle(
                          color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    "\$${sellingPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Insights Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Average Selling Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Avg Selling Time",
                      style: TextStyle(
                          color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    "$avgSellingTime days",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Top Buyers
              Row(
                children: topBuyers
                    .take(3)
                    .map(
                      (buyer) => Container(
                        margin: const EdgeInsets.only(left: 8),
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: Center(
                          child: Text(
                            buyer[0], // Display the first letter
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Actions Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Manage Stock", style: TextStyle(color:Colors.white)),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/add', arguments: Entry.fromItem(item, false));
                }, icon: Icon(Icons.add), label: Text("Add"), style: TextButton.styleFrom(foregroundColor: Color(0xFF00B3B3)),
                ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/add', arguments: Entry.fromItem(item, true));
                }, icon: Icon(Icons.remove), label: Text("Out"), style: TextButton.styleFrom(foregroundColor: Color(0xFFFF6D34)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
