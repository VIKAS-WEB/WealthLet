import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';
import 'package:wealthlet/features/Payments/Bloc/InternalTransferBloc/internal_transfer_bloc.dart';
import 'package:wealthlet/features/Payments/Bloc/InternalTransferBloc/internal_transfer_event.dart';
import 'package:wealthlet/features/Payments/Presentation/Widgets/balance_display.dart';

class InstantTransferScreen extends StatelessWidget {
  const InstantTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Instant Money Transfer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 23, 23, 23), ColorsField.buttonRed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: BlocProvider(
        create:
            (context) =>
                InternalTransferBloc(FlutterLocalNotificationsPlugin())
                  ..add(FetchAccountsEvent()),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance Section
              const Text(
                "Current Balance",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              BalanceDisplay(accountType: 'source', balanceTextStyle: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),),
              const SizedBox(height: 24),
              // Send and Request Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsField.buttonRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Send", style: TextStyle(fontSize: 16)),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Request",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Transactions Section
              const Text(
                "Transactions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: const [
                    TransactionItem(
                      icon: Icons.sentiment_satisfied_alt,
                      title: "Noon",
                      date: "Oct 25, 2024",
                      amount: "-\$14",
                      isCredit: false,
                    ),
                    TransactionItem(
                      icon: Icons.local_mall,
                      title: "Amazon",
                      date: "Oct 24, 2024",
                      amount: "+\$99",
                      isCredit: true,
                    ),
                    TransactionItem(
                      icon: Icons.payment,
                      title: "STC Pay",
                      date: "Oct 23, 2024",
                      amount: "+\$99",
                      isCredit: true,
                    ),
                    TransactionItem(
                      icon: Icons.phone,
                      title: "Vodafone",
                      date: "Oct 22, 2024",
                      amount: "-\$14",
                      isCredit: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final bool isCredit;

  const TransactionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCredit ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
