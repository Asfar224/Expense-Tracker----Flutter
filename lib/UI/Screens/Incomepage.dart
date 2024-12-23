import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_management_app/UI/Screens/Expenses.dart';

class AddIncomePage extends StatefulWidget {
  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final TextEditingController customIncomeTypeController =
      TextEditingController();
  final TextEditingController incomeAmountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController budgetcontroller = TextEditingController();

  String? selectedIncomeType;
  bool isCustomIncomeType = false;
  bool isbudget = false;

  final List<String> incomeTypes = [
    "Add Static Budget for Month",
    "Salary",
    "Others",
    "Custom",
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    customIncomeTypeController.dispose();
    incomeAmountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> addIncomeToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("User not logged in!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("User is not logged in! Please log in to continue.")),
      );
      return;
    }

    final String uid = user.uid;

    // Prepare the new income object
    final newIncome = {
      "type": selectedIncomeType == "Custom"
          ? customIncomeTypeController.text
          : selectedIncomeType,
      "amount": double.tryParse(incomeAmountController.text) ?? 0.0,
      "description": descriptionController.text,
      "timestamp": DateTime.now().toIso8601String(),
    };

    try {
      final userDocRef = _firestore.collection('users').doc(uid);

      // Check if the document exists
      final userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        // Append to existing "income" array
        await userDocRef.update({
          'income': FieldValue.arrayUnion([newIncome]),
        });
      } else {
        // Create document and add "income" array
        await userDocRef.set({
          'income': [newIncome],
        });
      }

      print("Income added successfully!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Income added successfully!")),
      );

      setState(() {
        customIncomeTypeController.clear();
        incomeAmountController.clear();
        descriptionController.clear();
        selectedIncomeType = null;
        isCustomIncomeType = false;
      });
    } catch (e) {
      print("Error adding income: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add income: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Income",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF4E1590),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIncomeForm(),
            const SizedBox(height: 35),
            _buildExpensePromptCard(context),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Color(0xFF4E1590)),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "GO TO DASHBOARD",
                style: TextStyle(
                  color: Color(0xFF4E1590),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Income Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Dropdown for Income Type
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Type of Income",
              border: OutlineInputBorder(),
            ),
            value: selectedIncomeType,
            items: incomeTypes
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedIncomeType = value;
                isCustomIncomeType = value == "Custom";
                isbudget = value == "Budget";
              });
            },
          ),
          const SizedBox(height: 16),
          // Custom Income Type Input
          if (isCustomIncomeType)
            TextField(
              controller: customIncomeTypeController,
              decoration: const InputDecoration(
                labelText: "Enter Custom Income Type",
                border: OutlineInputBorder(),
              ),
            ),
          const SizedBox(height: 16),

          TextField(
            controller: incomeAmountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Enter Amount",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          // Income Description Input
          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          // New Button
          ElevatedButton(
            onPressed: () {
              addIncomeToFirestore();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4E1590),
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 117),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Add Income",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensePromptCard(BuildContext context) {
    return Container(
      width: 350.0,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF4E1590),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Add your Expenses!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Expenses(),
                ),
              );
            },
            child: const Text(
              "Add",
              style: TextStyle(
                color: Color(0xFF4E1590),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
