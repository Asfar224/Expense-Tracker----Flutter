import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MiddleSection extends StatefulWidget {
  const MiddleSection({Key? key}) : super(key: key);

  @override
  _MiddleSectionState createState() => _MiddleSectionState();
}

class _MiddleSectionState extends State<MiddleSection> {
  final List<String> _categories = [
    'Food',
    'Transport',
    'Rent',
    'Utilities',
    'Entertainment',
    'Healthcare',
    'Shopping',
    'Other'
  ];

  Map<String, double> _categoryExpenses = {};
  double _totalExpenses = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  Future<void> _fetchExpenses() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      print("Fetching data for User ID: ${user.uid}");

      // Fetch user's document from the "users" collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = userDoc.data() as Map<String, dynamic>?;

      if (data == null || !data.containsKey('expenses')) {
        print("No expenses found for user.");
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      List<dynamic> expenses = data['expenses'] ?? [];
      print("Expenses Array: $expenses");

      Map<String, double> categoryExpenses = {};
      double totalExpenses = 0.0;

      for (var expense in expenses) {
        final String category = expense['type']?.toString() ?? 'Other';
        final double amount =
            double.tryParse(expense['amount']?.toString() ?? '0') ?? 0.0;

        categoryExpenses[category] = (categoryExpenses[category] ?? 0) + amount;
        totalExpenses += amount;
      }

      print("Fetched Category Expenses: $categoryExpenses");
      print("Total Expenses: $totalExpenses");

      if (mounted) {
        setState(() {
          _categoryExpenses = categoryExpenses;
          _totalExpenses = totalExpenses;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching expenses: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Spend Analysis",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                _categoryExpenses.isEmpty
                    ? const Text(
                        "No expenses found. Add expenses to display the summary.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _categories
                              .where((category) =>
                                  _categoryExpenses.containsKey(category))
                              .map((category) {
                            final double amount = _categoryExpenses[category]!;
                            final String percentage = _totalExpenses == 0
                                ? "0%"
                                : "${((amount / _totalExpenses) * 100).toStringAsFixed(1)}%";

                            return _SpendCard(
                              title: category,
                              percentage: percentage,
                              icon: _getIconForCategory(category),
                            );
                          }).toList(),
                        ),
                      ),
                const SizedBox(height: 20),
              ],
            ),
          );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant_menu;
      case 'Transport':
        return Icons.directions_car;
      case 'Rent':
        return Icons.home;
      case 'Utilities':
        return Icons.lightbulb;
      case 'Entertainment':
        return Icons.tv;
      case 'Healthcare':
        return Icons.local_hospital;
      case 'Shopping':
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }
}

class _SpendCard extends StatelessWidget {
  final String title;
  final String percentage;
  final IconData icon;

  const _SpendCard({
    Key? key,
    required this.title,
    required this.percentage,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // Set fixed width
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            percentage,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
