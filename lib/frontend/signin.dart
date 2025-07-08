import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  bool isPasswordVisible = false;

  Future<void> signIn(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.18.48/backend/signin.php'), // Update with your backend URL
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          // Navigate to home page after successful login
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(() {
            errorMessage = responseData['message']; // Use server message
          });
        }
      } else {
        // Handle non-200 responses
        setState(() {
          errorMessage = 'Error: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e'; // Generic error message
      });
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  // Welcome Text
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          "WELCOME\nRONA MALANG",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Ready to Explore Malang with\nRona Malang?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Form Card
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Let's Get Something",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Glad to see you back!",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 20),
                          // Username Field
                          TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              hintText: "Username",
                              prefixIcon: const Icon(Icons.person_outline,
                                  color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          // Password Field
                          TextFormField(
                            controller: passwordController,
                            obscureText: !isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline,
                                  color: Colors.grey),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          // Error Message
                          if (errorMessage.isNotEmpty)
                            Center(
                              child: Text(
                                errorMessage,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          // Log In Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (validateAndSave()) {
                                  signIn(
                                    usernameController.text,
                                    passwordController.text,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: const Text(
                                "Sign in",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Don't Have Account
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: "Don’t have an account? ",
                                style: const TextStyle(color: Colors.black54),
                                children: [
                                  TextSpan(
                                    text: "Sign up",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(context, '/signup');
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Divider with Text
                          Center(
                            child: Column(
                              children: [
                                const Divider(color: Colors.grey),
                                const Text(
                                  "or Sign In With",
                                  style: TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 10),
                                IconButton(
                                  onPressed: () {
                                    // Add your Google Sign-In logic here
                                  },
                                  icon: Image.asset('assets/google.png',
                                      height: 40),
                                ),
                                const SizedBox(height: 130),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
