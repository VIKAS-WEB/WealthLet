import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wealthlet/Presentation/Home/Auth/Login.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentIndex = 0;
  final List<String> _carouselTitles = [
    'Empowering Your Financial Journey, One Transaction At A Time.',
    'Transforming Your Finances Daily, One Move At A Time',
    'Navigating Your Wealth Pathway, One Step At A Time',
  ]; // You can modify these titles as needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(top: 30, left: 12),
          child: Icon(
            Icons.account_balance_wallet,
            size: 50.0,
            color: Colors.brown[900],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 30),
            child: Icon(Icons.info_outline, size: 30),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Carousel Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(_carouselTitles.length, (index) {
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.brown[900]
                          : Colors.grey[300],
                    ),
                  );
                }),
              ),
              SizedBox(height: 30.0),
              // Carousel Slider for Title
              CarouselSlider(
                options: CarouselOptions(
                  height: 230.0, // Adjust height based on text size
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.easeInOut,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: _carouselTitles.map((title) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Text(
                        title,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 30.0),
              // Subtitle text
              Text(
                'Empowering your financial journey, one transaction at a time, to help you achieve your goals and manage your money wisely.',
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40.0),
              // Get Started Button
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD1493B),
                      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: Text(
                      'Get Started Now',
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}