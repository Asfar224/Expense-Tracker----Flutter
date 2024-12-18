import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({Key? key}) : super(key: key);

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  String _type = '';
  String _amount = '';
  String _expenseName = ''; // New field
  String _description = ''; // New field

  // List of basic expense types for the dropdown
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

  // Function to submit data to Firebase
  Future<void> _submitExpense() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("User not logged in!");
        return;
      }

      final String uid = user.uid;

      // Prepare the new expense object
      final newExpense = {
        'name': _expenseName, // Added field
        'description': _description, // Added field
        'type': _type,
        'amount': _amount,
        'date': getCurrentDate(),
      };

      try {
        final docRef =
            FirebaseFirestore.instance.collection('expenses').doc(uid);

        // Check if the document exists
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          // Append to existing "expenses" array
          await docRef.update({
            'expenses': FieldValue.arrayUnion([newExpense]),
          });
        } else {
          // Create document and add "expenses" array
          await docRef.set({
            'expenses': [newExpense],
          });
        }

        print("Expense added successfully!");
        Navigator.pop(context); // Close the form after submission
      } catch (e) {
        print("Error adding expense: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 15.0,
              ),
              Text("Add Expenses", style: const TextStyle(fontSize: 25.0)),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Expense Name"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter expense name" : null,
                onSaved: (value) => _expenseName = value!,
              ),
              SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Expense Type"),
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
              SizedBox(height: 10.0),
              TextFormField(
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Please enter amount" : null,
                onSaved: (value) => _amount = value!,
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) =>
                    value!.isEmpty ? "Please enter description" : null,
                onSaved: (value) => _description = value!,
              ),
              const SizedBox(height: 35),
              ElevatedButton(
                onPressed: _submitExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4E1590),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  "ADD",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
