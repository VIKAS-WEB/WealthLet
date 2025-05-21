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
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(top: 0, left: 15),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              size: 25.0,
              color: Colors.brown[900],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 0),
            child: Icon(Icons.info_outline, size: 30),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 30.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
             // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                   Column(
                    children: [
                          Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 10.0),
                     child: Image.asset('assets/images/WealthLet.png', width: 250,),
                   ),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                     child: Divider(color:Colors.black12, thickness: 1,),
                   ),
                   SizedBox(height: 20,),
                      Text(
                  "SIGN UP",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                    ],
                   ),
                // Title text
                
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text(
                  "Let's fill up this form and fill it correctly",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 50.0),
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
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    hintText: 'Email',
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
                SizedBox(height: 16.0),
                // Password TextField
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: Icon(Icons.visibility, color: Colors.grey),
                    hintText: 'Confirm Password',
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
                ],),
                SizedBox(height: 40.0),
                // Subtitle text
                
                SizedBox(height: 16.0),
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have a account? ",
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => SignUp(),));
                      },
                      child: Text(
                        'Sign Up',
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
      ),
    );

  }
}