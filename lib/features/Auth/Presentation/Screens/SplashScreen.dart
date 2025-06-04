import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 350,
              height: 350,
              child: Container(
                child: Image.asset('assets/images/WealthLet.png', fit: BoxFit.contain,),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
