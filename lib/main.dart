import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthlet/features/Auth/Presentation/Screens/Login.dart';
import 'package:wealthlet/features/Home/Presentation/Screens/HomeScreen.dart';
import 'package:wealthlet/features/Home/Presentation/Screens/WelcomeScreen.dart';
import 'package:wealthlet/core/services/MessagingServices.dart';
import 'package:wealthlet/features/Profile/Bloc/profile_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize MessagingService
  final messagingService = MessagingService();
  await messagingService.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: LoginScreen(),
    );
  }
}
