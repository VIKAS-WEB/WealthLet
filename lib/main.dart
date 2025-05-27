import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wealthlet/Presentation/Home/Auth/Login.dart';
import 'package:wealthlet/Presentation/Home/Auth/SignUp.dart';
import 'package:wealthlet/Presentation/Home/Dashboard.dart';
import 'package:wealthlet/Presentation/Home/HomeScreen.dart';
import 'package:wealthlet/Presentation/WelcomeScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),                                                       
    );
  }
}