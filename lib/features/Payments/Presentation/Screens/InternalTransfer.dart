import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';
import 'package:wealthlet/main.dart';

class InternalTransferScreen extends StatefulWidget {
  const InternalTransferScreen({super.key});

  @override
  _InternalTransferScreenState createState() => _InternalTransferScreenState();
}

class _InternalTransferScreenState extends State<InternalTransferScreen>
    with RouteAware {
  final TextEditingController _amountController = TextEditingController();
  Map<String, dynamic>? sourceAccount;
  Map<String, dynamic>? destinationAccount;
  bool isLoading = true;
  String? errorMessage;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _amountController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    setState(() {
      isLoading = true;
      errorMessage = null;
      sourceAccount = null;
      destinationAccount = null;
    });
    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          errorMessage = 'User is not authenticated. Please sign in.';
          isLoading = false;
        });
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('accounts')
          .get();

      if (snapshot.docs.length >= 2) {
        setState(() {
          sourceAccount = snapshot.docs[0].data();
          destinationAccount = snapshot.docs[1].data();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'You need at least two accounts to make a transfer. Please add another account.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load accounts: $e';
        isLoading = false;
      });
      print('Error fetching accounts: $e');
    }
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
        'Transferred \₹${amount.toStringAsFixed(2)} (Transaction ID: $transactionId)',
        platformDetails,
      );
      print('Notification shown: Transferred \₹${amount.toStringAsFixed(2)} (ID: $transactionId)');
    } catch (e) {
      print('Failed to show notification: $e');
    }
  }

  Future<void> _processTransfer() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      setState(() {
        errorMessage = 'Please enter an amount.';
      });
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      setState(() {
        errorMessage = 'Please enter a valid positive amount.';
      });
      return;
    }

    if (sourceAccount == null || destinationAccount == null) {
      setState(() {
        errorMessage = 'Account data is missing. Please try again.';
      });
      return;
    }

    final sourceBalance = (sourceAccount!['balance'] is int
            ? (sourceAccount!['balance'] as int).toDouble()
            : sourceAccount!['balance'] as double?) ??
        0.0;
    if (sourceBalance < amount) {
      setState(() {
        errorMessage = 'Insufficient balance in source account.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    // Navigate to EnterMpinScreen with transfer details
    final result = await Navigator.pushNamed(
      context,
      '/enter_mpin',
      arguments: {
        'amount': amount,
        'sourceAccount': sourceAccount,
        'destinationAccount': destinationAccount,
      },
    );

    // Handle result from EnterMpinScreen
    setState(() {
      isLoading = false;
      if (result == true) {
        _amountController.clear();
      } else {
        errorMessage = 'Transfer cancelled or PIN verification failed.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transfer Between Accounts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 23, 23, 23), ColorsField.buttonRed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (errorMessage!.contains('two accounts'))
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/add_account'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsField.buttonRed,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Add New Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Source Account',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            sourceAccount?['type'] == 'Visa'
                                ? 'assets/images/Visa.png'
                                : 'assets/images/MasterCard.png',
                            width: 40,
                          ),
                          title: Text(
                            sourceAccount?['name'] ?? 'Visa Classic',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            sourceAccount?['number'] ?? '9182 **** **** 1177',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          trailing: Text(
                            '\₹${(sourceAccount?['balance'] is int
                                    ? (sourceAccount!['balance'] as int).toDouble()
                                    : sourceAccount?['balance'] as double?)?.toStringAsFixed(2) ?? '0.00'}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Destination Account',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            destinationAccount?['type'] == 'MasterCard'
                                ? 'assets/images/MasterCard.png'
                                : 'assets/images/Visa.png',
                            width: 40,
                          ),
                          title: Text(
                            destinationAccount?['name'] ?? 'MasterCard',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            destinationAccount?['number'] ?? '8473 **** **** 9932',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          trailing: Text(
                            '\₹ ${(destinationAccount?['balance'] is int
                                    ? (destinationAccount!['balance'] as int).toDouble()
                                    : destinationAccount?['balance'] as double?)?.toStringAsFixed(2) ?? '0.00'}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Amount',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          prefixText: '\₹ ',
                          prefixStyle: const TextStyle(fontSize: 18, color: Colors.black),
                          hintText: '0',
                          hintStyle: TextStyle(fontSize: 18, color: Colors.grey[400]),
                          border: const UnderlineInputBorder(),
                          errorText: errorMessage != null && !errorMessage!.contains('two accounts')
                              ? errorMessage
                              : null,
                        ),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _processTransfer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsField.buttonRed,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'NEXT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}