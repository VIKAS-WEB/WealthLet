import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealthlet/features/Auth/Bloc/app_start_event.dart';
import 'package:wealthlet/features/Auth/Bloc/app_start_state.dart';

class AppStartBloc extends Bloc<AppStartEvent, AppStartState> {
  AppStartBloc() : super(AppStartInitial()) {
    on<CheckIfFirstTime>(_onCheckIfFirstTime);
  }

  Future<void> _onCheckIfFirstTime(CheckIfFirstTime event, Emitter<AppStartState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('hasSeenWelcome') ?? false;
    await Future.delayed(Duration(seconds: 2));

    if (seen) {
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        emit(ShowHomeScreen());
      } else {
        emit(ShowLoginScreen());
      }
    } else {
      await prefs.setBool('hasSeenWelcome', true);
      emit(ShowWelcomeScreen());
    }
  }
}
