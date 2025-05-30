import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wealthlet/features/Travel/Presentation/Screens/DashboardScreenOfTravelPage.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';

class TravelWelcomeScreen extends StatelessWidget {
  const TravelWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/sea-beach.jpg'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay at the Top
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color.fromARGB(255, 31, 31, 31).withOpacity(0.8), // Teal color at the top
                  Colors.transparent, // Fades to transparent at the bottom
                ],
                stops: const [0.0, 0.5], // Gradient stops at 50% of the height
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Bar with Menu and Profile Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 35),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      // IconButton(
                      //   icon: const Icon(Icons.person_outline, color: Colors.white, size: 30),
                      //   onPressed: () {},
                      // ),
                    ],
                  ),
                  //const Spacer(),
                  // Main Text
                  SizedBox(height: 60,),
                  const Text(
                    "Discover The World",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorsField.backgroundLight,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    child: const Text(
                      "We are here to help you discover the world easily",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Let's Go Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => TravelDashboard(),));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsField.buttonRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Let's Go",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  //const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}