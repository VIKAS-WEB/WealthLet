import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthlet/features/Auth/Presentation/Screens/Splash_Router.dart';
import 'package:wealthlet/features/Home/Bloc/Scheduled_Bloc/ScheduledTransactionBloc.dart';
import 'package:wealthlet/core/services/MessagingServices.dart';
import 'package:wealthlet/features/Home/Presentation/Screens/HomeScreen.dart';
import 'package:wealthlet/features/Payments/Bloc/InternalTransferBloc/internal_transfer_bloc.dart';
import 'package:wealthlet/features/Payments/Presentation/Screens/AddAccount.dart';
import 'package:wealthlet/features/Payments/Presentation/Screens/InternalTransfer.dart';
import 'package:wealthlet/features/Payments/Presentation/Widgets/MpinVerification.dart';
import 'package:wealthlet/features/Payments/Presentation/Widgets/Reciept.dart';
import 'package:wealthlet/features/Payments/Presentation/Widgets/TransferSuccessScreen.dart';
import 'package:wealthlet/features/Profile/Bloc/profile_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 🔁 Global RouteObserver
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

/// Notification Plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize Notifications
  try {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  } catch (e) {
    print('Failed to initialize notifications: $e');
  }

  // Initialize MessagingService
  final messagingService = MessagingService();
  await messagingService.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
        BlocProvider<ScheduledTransactionBloc>(
            create: (context) => ScheduledTransactionBloc()),
        BlocProvider<InternalTransferBloc>(
            create: (context) =>
                InternalTransferBloc(FlutterLocalNotificationsPlugin())),
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
      navigatorObservers: [routeObserver],
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashRouter(),
        '/Home': (context) => HomeScreen(),
        '/enter_mpin': (context) => EnterMpinScreen(),
        '/internal_transfer': (context) => InternalTransferScreen(),
        '/transfer_success': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          final currentUser = FirebaseAuth.instance.currentUser;

          if (args is Map<String, dynamic> && currentUser != null) {
            final userId = args['userId'] as String?;
            print('Transfer success args: $args, currentUser: ${currentUser.uid}');

            if (userId == null || userId != currentUser.uid) {
              print('Invalid or missing userId: $userId');
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: Invalid user authentication. Please log in again.',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (route) => false,
                          );
                        },
                        child: Text('Go to Login'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return TransferSuccessScreen(
              transactionId: args['transactionId'] as String? ?? 'Unknown',
              amount: (args['amount'] is int
                      ? (args['amount'] as int).toDouble()
                      : args['amount'] as double?) ??
                  0.0,
              userId: userId, sourceAccount: {}, destinationAccount: {},
            );
          }

          print('Invalid args type: ${args.runtimeType} or no authenticated user');
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: Invalid transfer data or not authenticated.',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                    child: Text('Go to Login'),
                  ),
                ],
              ),
            ),
          );
        },
        '/add_account': (context) => AddAccountScreen(),
      },
    );
  }
}