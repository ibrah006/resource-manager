import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resource_manager/animated_circular_indiactors.dart';

class NoExpensesPlaceholderScreen extends StatelessWidget {
  const NoExpensesPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
                  height: MediaQuery.of(context).size.height,
                  color: const Color(0xFF222244), // Background color
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header Title
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "No Expenses Yet!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                
                      // Graphic Placeholder
                      AnimatedCircularIndiactors.sample(),
                      const SizedBox(height: 16),
                
                      // Body Text
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          "It seems like you haven’t added any expenses yet. Start tracking your spending today!",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 50),
                
                      // "Start Adding!" Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, "/add");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4D4DFF), // Button color
                            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Start Adding!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}