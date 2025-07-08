import 'package:flutter/material.dart';
import 'frontend/signin.dart';
import 'frontend/signup.dart';
import 'frontend/daftarmasuk.dart';
import 'frontend/home.dart'; // Import halaman Home

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rona Malang',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Splash screen adalah halaman awal
      routes: {
        '/': (context) => SplashScreen(), // Halaman Splash Screen
        '/daftarmasuk': (context) => DaftarMasukPage(), // Halaman Daftar Masuk
        '/signin': (context) => SignInPage(), // Halaman Sign In
        '/signup': (context) => SignUpPage(), // Halaman Sign Up
        '/home': (context) => HomePage(), // Tambahkan route untuk HomePage
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer untuk pindah ke halaman DaftarMasuk setelah 3 detik
    Future.delayed(Duration(seconds: 3), () {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/daftarmasuk');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 150), // Logo Aplikasi
              SizedBox(height: 20),
              Text(
                "Rona Malang",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
