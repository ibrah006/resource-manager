
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resource_manager/animated_circular_indiactors.dart';
import 'package:resource_manager/data_provider.dart';
import 'package:resource_manager/entry.dart';
import 'package:resource_manager/entry_tile.dart';

const INDICATORSTROKEWIDTH = 20.0;
const INDICATORDIAMETER = 300;

const COLORS = [
  Color(0xFF435BFB),
  Color(0xFF966EFD),
  Color(0xFFFECA14),
  Color(0xFFFF6D34),
  Color(0xFF00B3B3)
];

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  @override
  State<ExpensesScreen> createState() => _SpendingChartScreenState();
}

class _SpendingChartScreenState extends State<ExpensesScreen> with SingleTickerProviderStateMixin {
  // late List<double> indicatorValues;

  late final Iterable<Entry> entries;

  late double maxIndicatorValue;

  
  Map<String, double> indicatorValues = {};

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text("Expenses", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title and Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Spending",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                DropdownButton<String>(
                  value: "Monthly",
                  dropdownColor: const Color(0xFF222244),
                  style: const TextStyle(color: Colors.white),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  items: const [
                    DropdownMenuItem(value: "Monthly", child: Text("Monthly")),
                    DropdownMenuItem(value: "Weekly", child: Text("Weekly")),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
          ),

          // Top Section with AnimatedSize
          AnimatedCircularIndiactors(containerHeight: containerHeight, scaleFactor: scaleFactor, indicatorValues: indicatorValues, maxIndicatorValue: maxIndicatorValue),

          // Entries List Section
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                color: Colors.white.withOpacity(.1),
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return EntryTile(entries.elementAt(index));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  double containerHeight = 340; // Initial height of the top section
  double scaleFactor = 1.0; // Initial scale of the top section
  final ScrollController _scrollController = ScrollController();
  bool isExpanded = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // intialize animation stuff
    _scrollController.addListener(() {
      setState(() {
        // Adjust the scale factor based on scroll offset
        scaleFactor = (1.0 - (_scrollController.offset / 200).clamp(0.0, 0.5));
        containerHeight = 340 - (_scrollController.offset / 2).clamp(0.0, 100);
      });
    });

    // intialize data

    entries = Provider.of<DataProvider>(context, listen: false).entries;

    entries.forEach((entry) {
      final category = entry.category?? "Uncategorized";

      final updatedValue = (indicatorValues[category]?? 0) + entry.price;
      indicatorValues[category] = updatedValue;
    });

    print("categories: ${indicatorValues.keys}");

    // final List<double> temp = [];
    // indicatorValues = List.generate(
    //   4,
    //   (index) {

    //     late final double currentIndicatorMaxPercentage;
    //     try {
    //       currentIndicatorMaxPercentage = 100 - (temp.reduce((a, b)=> a + b));
    //     } catch(e) {
    //       currentIndicatorMaxPercentage = 50;
    //     }

    //     final indicatorValue = index!=3? Random().nextDouble() * currentIndicatorMaxPercentage : currentIndicatorMaxPercentage;
    //     temp.add(indicatorValue);

    //     return indicatorValue;
    //   }
    // );
    // indicatorValues.sort((a, b) => b.compareTo(a));

    // Convert the map to a list of entries and sort by the values in descending order
    var sortedEntries = indicatorValues.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));  // Sorting in descending order

    // Convert the sorted entries back to a map (if needed)
    indicatorValues = Map.fromEntries(sortedEntries);


    maxIndicatorValue = indicatorValues.values.reduce(max);
  }
}

class SpendingChartPainter extends CustomPainter {

  Color color;
  int percentage;

  SpendingChartPainter({required this.color, required this.percentage});
  
  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = INDICATORSTROKEWIDTH;

    // Chart data
    final segments = [
      {"percentage": percentage, "color": color},
    ];

    // Total percentage for calculations
    const double fullCircleDegrees = 270; // 75% of a full circle
    double startAngle = -135.0; // Start at the leftmost point (to center the arc visually)

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth;

    

    for (var segment in segments) {
      final sweepAngle = (segment['percentage'] as int) / 100 * fullCircleDegrees;
      final paint = Paint()
        ..color = segment['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Draw the arc
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        _degreesToRadians(startAngle),
        _degreesToRadians(sweepAngle),
        false,
        paint,
      );

      startAngle += sweepAngle; // Update start angle for the next segment
    }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }
}