import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wealthlet/features/Auth/Bloc/app_start_bloc.dart';
import 'package:wealthlet/features/Auth/Bloc/app_start_event.dart';
import 'package:wealthlet/features/Auth/Bloc/app_start_state.dart';
import 'package:wealthlet/features/Auth/Presentation/Screens/Login.dart';
import 'package:wealthlet/features/Auth/Presentation/Screens/SplashScreen.dart';
import 'package:wealthlet/features/Home/Presentation/Screens/HomeScreen.dart';
import 'package:wealthlet/features/Home/Presentation/Screens/WelcomeScreen.dart';

class SplashRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppStartBloc()..add(CheckIfFirstTime()),
      child: BlocBuilder<AppStartBloc, AppStartState>(
        builder: (context, state) {
          if (state is AppStartInitial) {
            return SplashScreen();
          } else if (state is ShowWelcomeScreen) {
            return WelcomeScreen();
          } else if (state is ShowLoginScreen) {
            return LoginScreen();
          } else if (state is ShowHomeScreen) {
            return HomeScreen(); // yahan apni home screen ka widget
          } else {
            return Scaffold(
              body: Center(child: Text("Unexpected error")),
            );
          }
        },
      ),
    );
  }
}

