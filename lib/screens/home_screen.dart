import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../constants/app_image_paths.dart';
import '../widgets/image_with_top_shadow_widget.dart';
import '../widgets/footer_widget.dart';
import '../data/data.dart';
import '../helpers/color_helper.dart';
import '../models/category_model.dart';
import '../models/expense_model.dart';
import '../widgets/bar_chart.dart';
import 'category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  _buildCategory(
      BuildContext context, Category category, double totalAmountSpent) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryScreen(category: category),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: const EdgeInsets.all(20.0),
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${(category.maxAmount - totalAmountSpent).toStringAsFixed(2)} / \$${category.maxAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double maxBarWidth = constraints.maxWidth;
                final double percent = (category.maxAmount - totalAmountSpent) /
                    category.maxAmount;
                double barWidth = percent * maxBarWidth;

                if (barWidth < 0) {
                  barWidth = 0;
                }
                return Stack(
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    Container(
                      height: 20.0,
                      width: barWidth,
                      decoration: BoxDecoration(
                        color: getColor(context, percent),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            forceElevated: true,
            pinned: true,
            // floating: true,
            expandedHeight: 200.0,
            leading: IconButton(
              icon: const Icon(Icons.settings),
              iconSize: 30.0,
              onPressed: () {},
            ),
            flexibleSpace: const FlexibleSpaceBar(
              title: Text("Simple Budget"),
              background: ImageWithTopShadowWidget(AppImagePaths.appBarImage),
            ),
            actions: [
              IconButton(
                  onPressed: () {}, iconSize: 30.0, icon: const Icon(Icons.add))
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: BarChart(weeklySpending),
                  );
                } else {
                  final Category category = categories[index - 1];
                  double totalAmountSpent = 0;
                  // 1st way: calc the sum with a loop
                  for (Expense expense in category.expenses) {
                    totalAmountSpent += expense.cost;
                  }

                  // 2nd way: calc with transform methods: 'map' and 'fold'
                  totalAmountSpent = category.expenses
                      .map((expense) => expense.cost)
                      .fold(0, (prev, amount) => prev + amount);

                  // 3rd way: calc with transform methods: 'map' and 'sum'
                  totalAmountSpent =
                      category.expenses.map((expense) => expense.cost).sum;

                  return _buildCategory(context, category, totalAmountSpent);
                }
              },
              childCount: 1 + categories.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: FooterWidget(),
          ),
        ],
      ),
    );
  }
}
