import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthlet/Presentation/Home/Auth/Login.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo placeholder (since we can't include images directly)
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
                'Empowering Your Financial Journey, One Transaction At A Time.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 16.0),
              // Subtitle text
              Text(
                'Empowering your financial journey, one transaction at a time, to help you achieve your goals and manage your money wisely.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40.0),
              // Get Started Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LoginScreen(),));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD1493B), // Button color
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: Text(
                  'Get Started Now',
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}