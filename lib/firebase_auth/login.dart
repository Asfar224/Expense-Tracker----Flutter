import 'package:expense_management_app/UI/Screens/landingpage.dart';
import 'package:flutter/material.dart';
import 'package:expense_management_app/firebase_auth/signup.dart';
import 'package:expense_management_app/Components/ErrorDisplayer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20.0, top: 95.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80.0),
              Text(
                "Welcome back!!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                "login to your account",
                style: TextStyle(
                  color: Color.fromARGB(255, 153, 153, 153),
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: 20.0),

              // Email field
              Text(
                "Email",
                style: TextStyle(fontSize: 16.0),
              ),
              TextFormField(
                controller: _emailcontroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: 'hello@example.com',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 153, 153, 153)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 153, 153, 153)),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              SizedBox(
                height: 18.0,
              ),

              // Password field
              Text(
                "Password",
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _passwordcontroller,
                obscureText: true,
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: const Color.fromARGB(255, 153, 153, 153)),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 153, 153, 153)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    )),
              ),
              SizedBox(height: 32.0),

              // Sign-in button
              ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                        child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 78, 21, 144),
                    minimumSize:
                        Size(double.infinity, 10), // Make button full width
                    textStyle: TextStyle(fontSize: 18.0),
                  ),
                  onPressed: () async {
                    final email = _emailcontroller.text;
                    final password = _passwordcontroller.text;

                    if (email.isNotEmpty && password.isNotEmpty) {
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        String uid = userCredential.user?.uid ?? '';

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LandingPage(uid: uid),
                          ),
                        );
                      } catch (exception) {
                        ErrorOverlay.show(
                            context, "Authentication Unsuccessful");
                      }
                    } else {
                      ErrorOverlay.show(
                          context, "Fill out all required fields");
                    }
                  }),
              SizedBox(height: 18.0),

              // Redirect to signup
              Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Does not have an account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(width: 5), // Add space between texts
                  GestureDetector(
                    onTap: () {
                      // Navigate to the signup page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SignupScreen(), // Your signup screen
                        ),
                      );
                    },
                    child: Text(
                      "Signup Here",
                      style: TextStyle(
                        color: const Color.fromARGB(
                            255, 16, 122, 208), // Blue color for link
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
