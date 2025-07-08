import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  bool isPasswordVisible = false;

  Future<void> signUp(String email, String username, String password) async {
    if (kDebugMode) {
      print('Trying to sign up with email: $email, username: $username');
    }
    try {
      final response = await http.post(
        Uri.parse('http://192.168.18.48/backend/signup.php'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': email,
          'username': username,
          'password': password,
        }),
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          // Navigate to home or dashboard
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(() {
            errorMessage = responseData['message'];
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
      if (kDebugMode) {
        print('Caught an error: $e');
      }
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
                        SizedBox(height: 20),
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
                            "Getting started",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Create account to continue!",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 20),
                          // Email Field
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: const Icon(Icons.email_outlined,
                                  color: Colors.grey),
                              filled: true,
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
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
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters';
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
                          // Sign Up Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (validateAndSave()) {
                                  signUp(
                                    emailController.text,
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
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Already Have Account
                          Center(
                            child: Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "Already have an account? ",
                                    style:
                                        const TextStyle(color: Colors.black54),
                                    children: [
                                      TextSpan(
                                        text: "Sign in",
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pop(context);
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Divider with Text
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
                                const SizedBox(height: 40),
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
