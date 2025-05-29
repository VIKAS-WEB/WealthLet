import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthlet/Presentation/Home/HomeScreen.dart';
import 'package:wealthlet/Presentation/WelcomeScreen.dart';
import 'package:wealthlet/utils/MessagingServices.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize MessagingService
  final messagingService = MessagingService();
  await messagingService.init();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: WelcomeScreen(),                                                          
    );
  }
}