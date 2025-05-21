import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthlet/Presentation/Home/Auth/Login.dart';
import 'package:wealthlet/Presentation/Home/HomeScreen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo placeholder
              Container(
                margin: EdgeInsets.only(bottom: 40.0),
                child: Icon(
                  Icons.account_balance_wallet,
                  size: 40.0,
                  color: Colors.brown[900],
                ),
              ),
              // Title text
              Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),
              // Subtitle text
              Text(
                "Let's fill up this form and fill it correctly",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 32.0),
              // Username TextField
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  hintText: 'Username',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              // Password TextField
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  suffixIcon: Icon(Icons.visibility, color: Colors.grey),
                  hintText: 'Password',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      color: Color(0xFFD1493B),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              // Login Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen(),));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD1493B),
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Submit',
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have a account? ",
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => LoginScreen(),));
                    },
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        color: Color(0xFFD1493B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}