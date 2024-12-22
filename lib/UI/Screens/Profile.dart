import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_management_app/firebase_auth/login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user; // Nullable User object
  String _name = "Loading...";
  String _email = "Loading...";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user == null) {
      // Redirect to login if the user is not logged in
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    } else {
      _fetchUserData();
    }
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _name = data['name'] ?? 'No Name';
          _email = _user!.email ?? 'No Email';
          _isLoading = false;
        });
      } else {
        setState(() {
          _name = 'No Name';
          _email = _user!.email ?? 'No Email';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Log out user
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Top section with profile details
                Container(
                  width: double.infinity,
                  height: 260.0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4E1590),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 55,
                          color: Color(0xFF4E1590),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 80.0),
                          Text(
                            _name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _email,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // List of menu items
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.notifications,
                            color: Color(0xFF4E1590)),
                        title: const Text(
                          'Notifications',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          // Handle notifications tap
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings,
                            color: Color(0xFF4E1590)),
                        title: const Text(
                          'Settings',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          // Handle settings tap
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.support_agent,
                            color: Color(0xFF4E1590)),
                        title: const Text(
                          'Support',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          // Handle support tap
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: _logout,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
