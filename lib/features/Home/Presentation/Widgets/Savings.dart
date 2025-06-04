import 'package:flutter/material.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';

class SavingsScreen extends StatelessWidget {
  // Sample data for recent transactions
  final List<Map<String, String>> transactions = [
    {'date': '01 Jun 2025', 'description': 'Deposit', 'amount': '+₹5,000'},
    {'date': '30 May 2025', 'description': 'Withdrawal', 'amount': '-₹2,000'},
    {'date': '28 May 2025', 'description': 'Interest Credited', 'amount': '+₹150'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 22, 22, 22), ColorsField.buttonRed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Savings',
          style: TextStyle(color: ColorsField.backgroundLight),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorsField.backgroundLight),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Balance Card with background image and shadow
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: ColorsField.buttonRed.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 6,
                  offset: Offset(0, 3), // Shadow position
                ),
              ],
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/CurrentBalance.jpg',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.10), // Dark overlay for better text readability
                  BlendMode.dst,
                ),
              ),
            ),
            child: Card(
              elevation: 0, // Elevation removed since shadow is handled by Container
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.transparent, // Card ko transparent kiya taaki background image dikhe
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Balance',
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorsField.backgroundLight.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '₹56,2554.29',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: ColorsField.backgroundLight,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Interest Rate',
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorsField.backgroundLight.withOpacity(0.9),
                              ),
                            ),
                            Text(
                              '3.5% p.a.',
                              style: TextStyle(
                                fontSize: 16,
                                color: ColorsField.backgroundLight,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Earned Interest',
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorsField.backgroundLight.withOpacity(0.9),
                              ),
                            ),
                            Text(
                              '₹1,200',
                              style: TextStyle(
                                fontSize: 16,
                                color: ColorsField.backgroundLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Action Buttons with ColorsField
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Transfer Money tapped!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsField.buttonRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Transfer Money',
                  style: TextStyle(color: ColorsField.backgroundLight),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Set Savings Goal tapped!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsField.buttonRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Set Savings Goal',
                  style: TextStyle(color: ColorsField.backgroundLight),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Recent Transactions with styled cards
          Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorsField.blackColor,
            ),
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
                child: ListTile(
                  leading: Icon(
                    transaction['amount']!.startsWith('+')
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: transaction['amount']!.startsWith('+')
                        ? ColorsField.buttonRed
                        : Colors.red,
                  ),
                  title: Text(
                    transaction['description']!,
                    style: TextStyle(color: ColorsField.blackColor),
                  ),
                  subtitle: Text(
                    transaction['date']!,
                    style: TextStyle(color: ColorsField.blackColor.withOpacity(0.7)),
                  ),
                  trailing: Text(
                    transaction['amount']!,
                    style: TextStyle(
                      color: transaction['amount']!.startsWith('+')
                          ? ColorsField.buttonRed
                          : Colors.red,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}