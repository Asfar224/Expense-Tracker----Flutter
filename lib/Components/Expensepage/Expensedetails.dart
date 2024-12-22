import 'package:flutter/material.dart';

class ExpenseDetailPage extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> expenses;

  ExpenseDetailPage({required this.category, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$category Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4E1590),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: expenses.isEmpty
          ? const Center(
              child: Text(
                'No expenses available for this category.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return _buildExpenseTile(expense);
              },
            ),
    );
  }

  Widget _buildExpenseTile(Map<String, dynamic> expense) {
    // Safely parse amount as a double
    final double? amount = double.tryParse(expense['amount']?.toString() ?? "");
    // Extract date and time from the 'date' field
    final String dateTime = expense['date']?.split('.')[0] ?? 'N/A';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 179, 179, 179),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            expense['name'] ?? 'N/A',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Description: ${expense['description'] ?? 'N/A'}",
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            "Amount: ₹${amount?.toStringAsFixed(2) ?? 'N/A'}",
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            "Date: $dateTime",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
