import 'package:flutter/material.dart';
import 'package:expense_management_app/UI/Screens/Homepage.dart';

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
    HomePage(), // Home Page
    Center(child: Text('Wallet Page')), // Placeholder for Wallet
    Center(child: Text('Budget Page')), // Placeholder for Budget
    Center(child: Text('Profile Page')), // Placeholder for Profile
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
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Budget',
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
