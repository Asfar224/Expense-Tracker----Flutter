import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_management_app/Components/Expensepage/Expenseform.dart';
import 'package:expense_management_app/Components/Expensepage/Expensedetails.dart';

class Expenses extends StatefulWidget {
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  List<Map<String, dynamic>> expenses = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    try {
      // Fetch the data from Firebase Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('expenses').get();

      Map<String, double> categorySums = {};

      // Process the fetched data
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?;

        // Ensure data is not null and contains the 'expenses' field
        if (data != null && data.containsKey('expenses')) {
          var expensesList = data['expenses'] as List<dynamic>?;

          // If the expenses array exists and is not empty
          if (expensesList != null && expensesList.isNotEmpty) {
            for (var expense in expensesList) {
              // Ensure each expense has the 'type' and 'amount' fields
              if (expense.containsKey('type') &&
                  expense.containsKey('amount')) {
                String type = expense['type'];
                double amount =
                    double.tryParse(expense['amount'].toString()) ?? 0.0;

                // Check if the type is one of the valid categories
                if ([
                  'Food',
                  'Transport',
                  'Rent',
                  'Utilities',
                  'Entertainment',
                  'Healthcare',
                  'Shopping',
                  'Other'
                ].contains(type)) {
                  categorySums[type] = (categorySums[type] ?? 0.0) + amount;
                }
              } else {
                print('Missing type or amount in expense: ${expense}');
              }
            }
          } else {
            print('No expenses array found in document: ${doc.id}');
          }
        } else {
          print('Document missing expenses field: ${doc.id}');
        }
      }

      // Convert categorySums to a list of expenses for UI
      setState(() {
        expenses = categorySums.entries.map((entry) {
          return {
            'type': entry.key,
            'amount': '₹${entry.value.toStringAsFixed(2)}',
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      // Log the error and show a message
      print('Error fetching expenses: $e');
      setState(() {
        errorMessage = 'Failed to load expenses: $e';
        isLoading = false;
      });
    }
  }

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
                color: Color.fromARGB(255, 255, 255, 255),
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

                  // Error Message or Loading Indicator
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (errorMessage.isNotEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  else
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
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ExpenseForm(),
                    ),
                    // Close Icon at the top right corner
                    Positioned(
                      right: -5,
                      top: -3,
                      child: IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.red, size: 30),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the Dialog
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: const Color(0xFF4E1590),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }

  // Single Expense Card
  Widget _buildExpenseCard(String expenseType, String amount) {
    return GestureDetector(
      onTap: () {
        // You can handle the card tap here, e.g., navigate to another page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExpenseDetailPage(category: expenseType),
          ),
        );
      },
      child: Container(
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
      ),
    );
  }
}
