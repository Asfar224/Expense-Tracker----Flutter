import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_management_app/Components/Expensepage/Expenseform.dart';
import 'package:expense_management_app/Components/Expensepage/Expensedetails.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Expenses extends StatefulWidget {
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  Map<String, List<Map<String, dynamic>>> categorizedExpenses = {};
  bool isLoading = true;
  String errorMessage = '';
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  double budgetUsedPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    fetchExpensesAndIncome();
  }

  Future<void> fetchExpensesAndIncome() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("User not logged in!");
        return;
      }
      String currentUserUid = user.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();
      print('User Document ID: ${userDoc.id}, Data: ${userDoc.data()}');

      var data = userDoc.data() as Map<String, dynamic>?;

      if (data != null) {
        // Fetch expenses and income
        var expensesList = data['expenses'] as List<dynamic>?;
        var incomeList = data['income'] as List<dynamic>?;

        if (expensesList != null && expensesList.isNotEmpty) {
          Map<String, List<Map<String, dynamic>>> tempCategorizedExpenses = {};

          for (var expense in expensesList) {
            if (expense is Map<String, dynamic> &&
                expense.containsKey('type') &&
                expense.containsKey('amount')) {
              String category = expense['type'];
              tempCategorizedExpenses.putIfAbsent(category, () => []);
              tempCategorizedExpenses[category]?.add({
                'name': expense['name'] ?? 'Unnamed',
                'amount': expense['amount'],
                'description': expense['description'] ?? 'No description',
                'date': expense['date'] ?? '',
              });
              totalExpenses +=
                  (double.tryParse(expense['amount'].toString()) ?? 0.0);
            } else {
              print('Invalid expense data: $expense');
            }
          }

          setState(() {
            categorizedExpenses = tempCategorizedExpenses;
          });
        } else {
          print('No expenses array found in user document.');
        }

        // Calculate total income
        if (incomeList != null && incomeList.isNotEmpty) {
          for (var income in incomeList) {
            if (income is Map<String, dynamic> &&
                income.containsKey('amount')) {
              totalIncome +=
                  (double.tryParse(income['amount'].toString()) ?? 0.0);
            } else {
              print('Invalid income data: $income');
            }
          }
        } else {
          print('No income array found in user document.');
        }

        // Calculate budget used percentage
        if (totalIncome > 0) {
          budgetUsedPercentage = (totalExpenses / totalIncome) * 100;
        }

        setState(() {
          isLoading = false;
        });
      } else {
        print('User document missing expenses or income field.');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching expenses and income: $e');
      setState(() {
        errorMessage = 'Failed to load expenses and income: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4E1590),
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
              children: [
                isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        "${budgetUsedPercentage.toStringAsFixed(2)}% used",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                SizedBox(height: 6),
                isLoading
                    ? const SizedBox.shrink()
                    : const Text(
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

                  // Loading Indicator positioned below Expense Categories heading
                  if (isLoading)
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (errorMessage.isNotEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          errorMessage,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  else
                    // Expense Category Total Cards
                    Expanded(
                      child: ListView.builder(
                        itemCount: categorizedExpenses.length,
                        itemBuilder: (context, index) {
                          String category =
                              categorizedExpenses.keys.elementAt(index);
                          List<Map<String, dynamic>> categoryExpenses =
                              categorizedExpenses[category]!;
                          double totalAmount = categoryExpenses.fold(
                            0.0,
                            (sum, expense) =>
                                sum +
                                (double.tryParse(
                                        expense['amount'].toString()) ??
                                    0.0),
                          );
                          return _buildExpenseCard(
                            category,
                            '₹${totalAmount.toStringAsFixed(2)}',
                            categoryExpenses,
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
                      child: ExpenseForm(
                        onExpenseAdded: () {
                          fetchExpensesAndIncome();
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ),
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
  Widget _buildExpenseCard(String expenseType, String amount,
      List<Map<String, dynamic>> categoryExpenses) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExpenseDetailPage(
              category: expenseType,
              expenses: categoryExpenses,
            ),
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
