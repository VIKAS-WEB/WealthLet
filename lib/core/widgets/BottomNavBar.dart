import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wealthlet/features/Home/Presentation/Screens/Dashboard.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  // List of widgets to display for each tab
  static final List<Widget> _widgetOptions = <Widget>[
    Dashboard(), // Home tab displays the Dashboard
    Center(child: Text('Card Screen')),
    Center(child: Text('QR Code Screen')),
    Center(child: Text('Transaction Screen')),
    Center(child: Text('Budget Screen')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Card',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: (){
                Navigator.push(context, CupertinoPageRoute(
                  builder: (context) => QRScannerScreen(),));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF5733),
                    ),
                  ),
                  Icon(
                    Icons.qr_code,
                    color: Colors.white,
                    size: 30, // Adjusted size for better visibility
                  ),
                ],
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFFF5733),
        unselectedItemColor: Color(0xFFA9A9A9),
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}