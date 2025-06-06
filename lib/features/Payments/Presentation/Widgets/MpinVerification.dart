import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';
import 'dart:typed_data';

class EnterMpinScreen extends StatefulWidget {
  const EnterMpinScreen({super.key});

  @override
  _EnterMpinScreenState createState() => _EnterMpinScreenState();
}

class _EnterMpinScreenState extends State<EnterMpinScreen> {
  String errorMessage = "";
  final String correctPin = "1234"; // Replace with secure storage in production
  String enteredPin = "";
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
   // _controller.dispose();
   // _focusNode.dispose();
    super.dispose();
  }

  Future<void> _showNotification(double amount, String transactionId) async {
    final androidDetails = AndroidNotificationDetails(
      'transfer_channel',
      'Transfer Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      enableVibration: true,
      vibrationPattern: Int64List.fromList(const [0, 500, 200, 500]),
    );
    const iosDetails = DarwinNotificationDetails(
      sound: 'notification_sound.mp3',
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
    );
    final platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Transfer Successful',
        'Transferred ₹${amount.toStringAsFixed(2)} (Transaction ID: $transactionId)',
        platformDetails,
      );
      print('Notification shown: ₹$amount (ID: $transactionId)');
    } catch (e) {
      print('Failed to show notification: $e');
    }
  }

  Future<void> _processTransfer(
    double amount,
    Map<String, dynamic> sourceAccount,
    Map<String, dynamic> destinationAccount,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          setState(() {
            errorMessage = 'User is not authenticated. Please sign in.';
            _isProcessing = false;
          });
        }
        return;
      }

      final sourceBalance =
          (sourceAccount['balance'] is int
              ? (sourceAccount['balance'] as int).toDouble()
              : sourceAccount['balance'] as double?) ??
          0.0;
      final destBalance =
          (destinationAccount['balance'] is int
              ? (destinationAccount['balance'] as int).toDouble()
              : destinationAccount['balance'] as double?) ??
          0.0;

      final batch = FirebaseFirestore.instance.batch();
      final transactionId =
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('transactions')
              .doc()
              .id;

      final sourceRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('accounts')
          .doc(sourceAccount['accountId']);
      batch.update(sourceRef, {'balance': sourceBalance - amount});

      final destRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('accounts')
          .doc(destinationAccount['accountId']);
      batch.update(destRef, {'balance': destBalance + amount});

      final transactionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(transactionId);
      batch.set(transactionRef, {
        'type': 'transfer',
        'sourceAccountId': sourceAccount['accountId'],
        'destinationAccountId': destinationAccount['accountId'],
        'amount': amount,
        'date': Timestamp.now(),
        'status': 'completed',
      });

      await batch.commit();
      await _showNotification(amount, transactionId);

      if (mounted) {
        await Navigator.pushReplacementNamed(
          context,
          '/transfer_success',
          arguments: {'transactionId': transactionId, 'amount': amount, 'userId':user.uid},
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to process transfer: $e';
          _isProcessing = false;
        });
      }
      print('Transfer error: $e');
    }
  }

  void validatePin() {
    if (!mounted || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    if (enteredPin == correctPin) {
      if (mounted) {
        setState(() {
          errorMessage = "";
          enteredPin = "";
          _controller.clear(); // ✅ Safe because we're still mounted
        });
      }

      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        final double amount = args['amount'];
        final Map<String, dynamic> sourceAccount = args['sourceAccount'];
        final Map<String, dynamic> destinationAccount =
            args['destinationAccount'];

        _processTransfer(amount, sourceAccount, destinationAccount);
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Transfer data missing.';
            _isProcessing = false;
          });
          Navigator.pop(context, false);
        }
      }
    } else {
      if (mounted) {
        setState(() {
          errorMessage = "Incorrect PIN. Please try again.";
          enteredPin = "";
          _controller.clear(); // ✅ Also safe here
          _isProcessing = false;
        });

        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _focusNode.requestFocus();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            if (mounted && !_isProcessing) {
              Navigator.pop(context, false);
            }
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Mpin Verification',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 22, 22, 22), ColorsField.buttonRed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Please enter Mpin",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Mpin is a four-digit PIN set to secure your Wealthlet Banking Application",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            PinCodeTextField(
              appContext: context,
              length: 4,
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              autoFocus: true,
              enabled: !_isProcessing,
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorsField.buttonRed,
              ),
              cursorColor: ColorsField.buttonRed,
              animationType: AnimationType.none,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 65,
                fieldWidth: 65,
                activeColor: Colors.grey,
                inactiveColor: Colors.grey,
                selectedColor: Colors.grey,
                activeFillColor: ColorsField.buttonRed,
                inactiveFillColor: Colors.white,
                selectedFillColor: ColorsField.buttonRed,
                fieldOuterPadding: const EdgeInsets.all(10),
              ),
              onChanged: (value) {
                if (mounted && !_isProcessing) {
                  setState(() {
                    enteredPin = value;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Forgot Mpin?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height:10),
                Text(
                  "Log out of the App and tap on 'Forgot Mpin?' to reset your MPIN.",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _isProcessing ? null : validatePin,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsField.buttonRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  _isProcessing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
