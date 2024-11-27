

import 'dart:math';


import 'package:flutter/material.dart';
import 'package:resource_manager/concepts.dart';
import 'package:collection/collection.dart';


class AnimatedCircularIndiactors extends StatefulWidget {

  const AnimatedCircularIndiactors({
    super.key,
    required this.containerHeight,
    required this.scaleFactor,
    required this.indicatorValues,
    required this.maxIndicatorValue,
    this.isSample = false,
  });

  static AnimatedCircularIndiactors sample() {
    return AnimatedCircularIndiactors(
      containerHeight: 340,
      scaleFactor: 1,
      indicatorValues: _getSamples(),
      maxIndicatorValue: 4.0,
      isSample: true,);
  }

  static Map<String, double> _getSamples() {
    return {
      "0": 4.0,
      "1": 3.0,
      "2": 2.0,
      "3": 1.0
    };
  }

  final double containerHeight;
  final double scaleFactor;
  final double maxIndicatorValue;
  final Map<String, double> indicatorValues;
  final bool isSample;

  @override
  State<AnimatedCircularIndiactors> createState() => _AnimatedCircularIndiactorsState();
}

class _AnimatedCircularIndiactorsState extends State<AnimatedCircularIndiactors> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 0, child: Text("sample value: ${sampleAnimatorValue}", style: TextStyle(color: const Color(0xFF222244)))),
        Stack(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: widget.containerHeight,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(16.0).copyWith(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF222244),
                  borderRadius: BorderRadius.circular(38),
                ),
                child: Center(
                  child: Transform.translate(
                    offset: Offset(widget.scaleFactor < .75? (MediaQuery.of(context).size.width/2) - INDICATORDIAMETER*widget.scaleFactor : 0, 0),
                    child: AnimatedScale(
                      scale: widget.scaleFactor,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: SizedBox(
                        width: 300,
                        child: Stack(
                          children: List.generate(
                            widget.indicatorValues.length < 4? widget.indicatorValues.length : 4,
                            (index) {
                              final offset = (INDICATORSTROKEWIDTH * index);
                                
                              final indicatorValue = widget.indicatorValues.values.elementAt(index);
                                
                              late final int localPercentage;
                              try {
                                localPercentage =
                                    (((indicatorValue / widget.maxIndicatorValue) * 100) * (widget.isSample? (sampleAnimatorValue) : (widget.scaleFactor < .9? (1.32 * ((1 - widget.scaleFactor) + .5)) : 1)) ) 
                                        .toInt();
                                // print("indicatorValue: $indicatorValue / maxIndicatorValue: $maxIndicatorValue = $localPercentage");
                              } catch (e) {
                                localPercentage = 0;
                              }
                                
                              final Color color = COLORS[index];
                                
                              return Stack(
                                children: [
                                  // CustomPaint section
                                  Container(
                                    height: (INDICATORDIAMETER - (offset * 2)) * widget.scaleFactor,
                                    width: INDICATORDIAMETER - (offset * 2),
                                    margin:
                                        EdgeInsets.only(top: ((INDICATORSTROKEWIDTH) * (index) * widget.scaleFactor) , left: offset ),
                                    child: Transform.flip(
                                      flipX: true,
                                      child: Transform.rotate(
                                        angle: pi / 3.8,
                                        child: CustomPaint(
                                          painter: SpendingChartPainter(
                                              color: color,
                                              percentage: localPercentage.toInt()),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ... widget.scaleFactor > .9? [
                                    // Indicator Dot
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: ((INDICATORSTROKEWIDTH) *
                                                  (index + 1) -
                                              4),
                                          left: (INDICATORDIAMETER / 2) - 6),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Colors.white),
                                      height: 7,
                                      width: 7),
                                    // Labels
                                    if (!widget.isSample) Container(
                                      margin: EdgeInsets.only(
                                          top: ((INDICATORSTROKEWIDTH) *
                                                  (index + 1) -
                                              (10)),
                                          left: (INDICATORDIAMETER / 2) + 16.5),
                                      child: labels(index),
                                    )
                                  ] : []
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.scaleFactor<.8) Padding(
              padding: EdgeInsets.only(left: 30, top: 35),
              child: Column(
                children: List.generate(widget.indicatorValues.length, (index)=> labels(index, showLaeblColors: true)),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget labels(int index, {bool showLaeblColors = false}) {

    final category = widget.indicatorValues.keys.elementAt(index);

    final indicatorValue = widget.indicatorValues.values.elementAt(index);
              
    final double combinedPercentage = (indicatorValue / widget.indicatorValues.values.sum) * 100;

    late final Color color;
    try {
      color = COLORS[index];
    } catch(e) {
      color = COLORS[COLORS.length - 1];
    }

    return Row(
      children: [
        if (showLaeblColors) Container(
          height: 15,
          width: 7,
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20)
          ),
        ),
        Flexible(
            child: Text(
                category,
                style: TextStyle(
                    color: Colors.white
                        .withOpacity(.65),
                    overflow:
                        TextOverflow.ellipsis))),
        const SizedBox(width: 5),
        Text("${combinedPercentage.toInt()}%",
            style: const TextStyle(
                color: Colors.white)),
      ],
    );
  }

  late AnimationController _controller;
  double sampleAnimatorValue = 1;

  @override
  void initState() {
    super.initState();

    // if (widget.isSample) {
      // Initialize the controller
      _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 350),
        lowerBound: 0.0,
        upperBound: .32
      );

      // Delay before starting the animation
      Future.delayed(const Duration(seconds: 1)).then((value) {
        _controller.forward();
      });

      _controller.addListener(() {
        setState(() {
          // Update the animation value in setState
          sampleAnimatorValue = _controller.value + 1;
        });
        print("value $sampleAnimatorValue");
      });
    // }
  }

  @override
  void dispose() {
    // Dispose the controller when done
    if (widget.isSample) {
      _controller.dispose();
    }
    super.dispose();
  }
}