import 'dart:math';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class BarChart extends StatelessWidget {
  final List<double> expenses;
  final List<String> weekLabels = const [
    'Su',
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa'
  ];

  const BarChart(this.expenses, {Key? key}) : super(key: key);

  List<Widget> _buildWeekSpendingList() {
    double mostExpensive = expenses.max;

    List<Widget> weeklySpendingList = [];
    for (int i = 0; i < expenses.length; i++) {
      weeklySpendingList.add(Bar(
        label: weekLabels[i],
        amountSpent: expenses[i],
        mostExpensive: mostExpensive,
      ));
    }
    return weeklySpendingList;
  }

  @override
  Widget build(BuildContext context) {
    // Find the max value in the expenses list
    double mostExpensive = 0;

    // 1st way: using loop
    for (double price in expenses) {
      if (price > mostExpensive) {
        mostExpensive = price;
      }
    }
    // 2nd way: using collection method: 'fold' and 'max' in math.dart
    mostExpensive = expenses.fold(0, max);

    // 3rd way: using built-in collection package
    mostExpensive = expenses.sum;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          const Text(
            'Weekly Spending',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: 30.0,
                onPressed: () {},
              ),
              const Expanded(
                child: Text(
                  'Jun 05, 2022 - Jun 11, 2022',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                iconSize: 30.0,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _buildWeekSpendingList(),
          ),
        ],
      ),
    );
  }
}

class Bar extends StatelessWidget {
  final String label;
  final double amountSpent;
  final double mostExpensive;

  final double _maxBarHeight = 150.0;

  const Bar(
      {Key? key,
      this.label = "",
      this.amountSpent = 0.0,
      this.mostExpensive = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final barHeight = amountSpent / mostExpensive * _maxBarHeight;
    return Column(
      children: <Widget>[
        Text(
          '\$${amountSpent.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6.0),
        Container(
          height: barHeight,
          width: 18.0,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
