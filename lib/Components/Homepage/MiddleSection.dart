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
      // Get the current user
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      // Fetch expenses from Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .doc(user.uid)
          .collection('userExpenses')
          .get();

      Map<String, double> categoryExpenses = {};
      double totalExpenses = 0.0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final String category = data['type'] ?? 'Other';
        final double amount = (data['amount'] ?? 0).toDouble();

        categoryExpenses[category] = (categoryExpenses[category] ?? 0) + amount;
        totalExpenses += amount;
      }

      setState(() {
        _categoryExpenses = categoryExpenses;
        _totalExpenses = totalExpenses;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching expenses: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                SingleChildScrollView(
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

// Spend Card Widget
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
      width: 120,
      margin: const EdgeInsets.only(right: 16),
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
