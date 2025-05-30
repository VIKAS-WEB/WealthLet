import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';

class MyWalletApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWalletScreen(),
    );
  }
}

class MyWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back arrow and title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: ColorsField.blackColor,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'My Wallet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 24), // Spacer for symmetry
                ],
              ),
            ),
             
            // Balance Card 
            Container(
              width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorsField.buttonRed, // Light green
                    Colors.white,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Balance',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorsField.backgroundLight,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '0.00 ₹',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ColorsField.backgroundLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Illustration (Placeholder)
            SizedBox(height: 20),
            Container(
              width: 250,
              height: 250,
              child: Lottie.asset(
                'assets/lottie/Empty.json',
                fit: BoxFit.contain,
                repeat: true, // Loop the animation
              ),
            ),

            // Message
            SizedBox(height: 10),
            Text(
              'No balance available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Your balance and all transactions will be shown through cardlist',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),

            Spacer(), // Pushes the button to the bottom

            // Top Up Button
            Container(
              width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
              height: 48,
              margin: EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsField.buttonRed, // Background color
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Top up',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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