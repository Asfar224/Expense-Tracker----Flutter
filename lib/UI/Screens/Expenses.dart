import 'package:flutter/material.dart';

class Expenses extends StatelessWidget {
  final List<Map<String, dynamic>> expenses = [
    {'type': 'Food and drinks', 'amount': '₹20,000'},
    {'type': 'Entertainment', 'amount': '₹8,000'},
    {'type': 'Shopping', 'amount': '₹15,000'},
    {'type': 'Utilities', 'amount': '₹5,000'},
    {'type': 'Transport', 'amount': '₹3,000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4E1590),
      body: Column(
        children: [
          // Upper Section with Gradient
          Container(
            width: double.infinity,
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 109, 37, 192),
                  Color(0xFF4E1590),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "80% used",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "from your Total Budget",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Middle Section
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 197, 149, 149),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 209, 208, 208),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  // Expense Categories Heading
                  const Padding(
                    padding: EdgeInsets.only(left: 18),
                    child: Text(
                      "Expense Categories",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Expense Cards
                  Expanded(
                    child: ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        return _buildExpenseCard(
                          expenses[index]['type'],
                          expenses[index]['amount'],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Add Expense Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to add a new expense
          print("Add new expense");
        },
        backgroundColor: const Color(0xFF4E1590),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }

  // Single Expense Card
  Widget _buildExpenseCard(String expenseType, String amount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 209, 208, 208),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.purple.shade50,
                child: const Icon(
                  Icons.category,
                  color: Color(0xFF4E1590),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                expenseType,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
