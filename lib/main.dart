import 'package:expense_management_app/firebase_auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize Firebase asynchronously
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                  child:
                      Text('Firebase initialization error: ${snapshot.error}')),
            ),
          );
        }

        // Show a loading indicator while Firebase is initializing
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()), // Show loading
            ),
          );
        }

        // Once complete, show the main application
        return MaterialApp(
          title: 'Expense Tracker',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SignupScreen(),
        );
      },
    );
  }
}
