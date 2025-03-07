import 'package:flutter/material.dart';
import 'package:expense_management_app/UI/Screens/Homepage.dart';
import 'package:expense_management_app/UI/Screens/Incomepage.dart';
import 'package:expense_management_app/UI/Screens/Expenses.dart';
import 'package:expense_management_app/UI/Screens/Profile.dart';

class BottomNavigationPage extends StatefulWidget {
  final String uid;

  const BottomNavigationPage({Key? key, required this.uid}) : super(key: key);

  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _currentIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = [
    HomePage(),
    Expenses(),
    AddIncomePage(),
    ProfilePage() // Placeholder for Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromARGB(255, 98, 58, 144),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Add Income',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
