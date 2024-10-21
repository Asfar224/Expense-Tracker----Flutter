import 'package:flutter/material.dart';
import 'package:expense_management_app/firebase_auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:expense_management_app/Components/ErrorDisplayer.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers to retrieve the values from the input fields
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<User?> signUpWithGoogle() async {
    final GoogleSignIn googleSignIn = await GoogleSignIn();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return userCredential.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 25.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.0),
            Text(
              "Create an account",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0), // Space between text and input fields

            // Name input field
            Text('Name',
                style: TextStyle(fontSize: 16.0)), // Label above input field
            SizedBox(height: 8.0), // Space between label and input field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                  hintText: 'John Doe',
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
            SizedBox(height: 18.0), // Space between input fields

            // Email input field
            Text('Email', style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 8.0),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'hello@example.com',
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
            SizedBox(height: 18.0),

            // Password input field
            Text(
              "Password",
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: _passwordController,
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
            SizedBox(height: 28.0),

            Text("By continuing, you agree to our terms of service. ",
                style: TextStyle(
                  color: Colors.grey[500],
                  wordSpacing: 3.0,
                )),
            SizedBox(height: 16.0),

            // Sign Up button
            ElevatedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                    child: Text(
                  'Sign Up',
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
                final email = _emailController.text;
                final password = _passwordController.text;
                final name = _nameController.text;

                if (email.isNotEmpty &&
                    password.isNotEmpty &&
                    name.isNotEmpty) {
                  if (password.length < 8) {
                    ErrorDisplayer(
                        errorMessage: "Password Must be 8 characters long");
                  } else {
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email, password: password);
                    } catch (exception) {
                      ErrorDisplayer(errorMessage: "Firebase Auth Error");
                    }
                  }
                } else {
                  ErrorDisplayer(errorMessage: "Fill out the required feilds");
                }
              },
            ),
            SizedBox(height: 30.0),

            // Divider

            const Row(
              children: <Widget>[
                Expanded(
                  child: Divider(
                    color: Color.fromARGB(255, 230, 221, 221), // Line color
                    thickness: 1, // Line thickness
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "or",
                    style: TextStyle(color: Color.fromARGB(255, 202, 188, 188)),
                  ), // Text in the middle
                ),
                Expanded(
                  child: Divider(
                    color: Color.fromARGB(255, 230, 221, 221), // Line color
                    thickness: 1, // Line thickness
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30.0),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                    child: Text(
                  'Continue with google',
                  style:
                      TextStyle(color: const Color.fromARGB(255, 72, 70, 70)),
                )),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 179, 176, 179),
                minimumSize:
                    Size(double.infinity, 10), // Make button full width
                textStyle: TextStyle(fontSize: 18.0),
              ),
              onPressed: () async {
                await signUpWithGoogle();
              },
            ),
            SizedBox(
              height: 18.0,
            ),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(width: 5), // Add space between texts
                  GestureDetector(
                    onTap: () {
                      // Navigate to the login page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen(), // Your login screen
                        ),
                      );
                    },
                    child: const Text(
                      "Login Here",
                      style: TextStyle(
                        color: const Color.fromARGB(
                            255, 16, 122, 208), // Blue color for link
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
