import 'package:flutter/material.dart';

class ExpenseDetailPage extends StatelessWidget {
  final String category;

  ExpenseDetailPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Expenses'),
        backgroundColor: const Color(0xFF4E1590),
      ),
      body: Center(
        child: Text('Display expenses for $category here'),
      ),
    );
  }
}
