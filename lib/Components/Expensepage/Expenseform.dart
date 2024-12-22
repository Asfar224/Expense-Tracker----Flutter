import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseForm extends StatefulWidget {
  final VoidCallback?
      onExpenseAdded; // Callback to notify when expense is added

  const ExpenseForm({Key? key, this.onExpenseAdded})
      : super(key: key); // Constructor with optional callback

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  String _type = '';
  String _amount = '';
  String _expenseName = '';
  String _description = '';
  bool _isLoading = false; // Loading state to show progress

  final List<String> _expenseTypes = [
    'Food',
    'Transport',
    'Rent',
    'Utilities',
    'Entertainment',
    'Healthcare',
    'Shopping',
    'Other',
  ];

  // Function to get current date
  String getCurrentDate() {
    return DateTime.now().toString();
  }

  Future<void> _submitExpense() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading spinner when submitting
      });

      _formKey.currentState!.save();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("User not logged in!");
        return;
      }

      final String uid = user.uid;

      final newExpense = {
        'name': _expenseName,
        'description': _description,
        'type': _type,
        'amount': _amount,
        'date': getCurrentDate(),
      };

      try {
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(uid);

        final userDocSnapshot = await userDocRef.get();

        if (userDocSnapshot.exists) {
          await userDocRef.update({
            'expenses': FieldValue.arrayUnion([newExpense]),
          });
        } else {
          await userDocRef.set({
            'expenses': [newExpense],
          });
        }

        print("Expense added successfully!");

        // Call the callback function passed from the parent widget
        if (widget.onExpenseAdded != null) {
          widget.onExpenseAdded!();
        }

        // Close the dialog (Form) without navigating to the login page
        Navigator.of(context).pop();
      } catch (e) {
        print("Error adding expense: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding expense: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator after operation
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15.0),
                  const Text("Add Expenses", style: TextStyle(fontSize: 25.0)),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Expense Name"),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter expense name" : null,
                    onSaved: (value) => _expenseName = value!,
                  ),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: "Expense Type"),
                    value: _type.isNotEmpty ? _type : null,
                    items: _expenseTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? "Please select expense type"
                        : null,
                    onSaved: (value) => _type = value!,
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Amount"),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? "Please enter amount" : null,
                    onSaved: (value) => _amount = value!,
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter description" : null,
                    onSaved: (value) => _description = value!,
                  ),
                  const SizedBox(height: 35),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitExpense,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4E1590),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "ADD",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
