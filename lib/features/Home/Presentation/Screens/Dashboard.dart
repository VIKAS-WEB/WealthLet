import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // Import mobile_scanner package
import 'package:wealthlet/features/Travel/Presentation/Screens/TravelWelcomeScreen.dart';
import 'package:wealthlet/features/Auth/Presentation/Screens/Login.dart';
import 'package:wealthlet/features/Profile/Presentation/Screens/profile.dart';
import 'package:wealthlet/features/Payments/Presentation/Screens/BankTransfer.dart';
import 'package:wealthlet/features/Payments/Presentation/Screens/CardPayment.dart';
import 'package:wealthlet/features/Payments/Presentation/Screens/InstantTransfer.dart';
import 'package:wealthlet/features/Payments/Presentation/Screens/InternalTransfer.dart';
import 'package:wealthlet/features/Payments/Presentation/Screens/WalletScreens.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';
import 'package:wealthlet/core/services/notifications.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // List of card data for the carousel
  final List<Map<String, String>> cards = [
    {'number': '**** **** **** 1234', 'imageUrl': 'assets/images/card1.jpg'},
  ];

  final Map<String, Widget> routeMap = {
    'Internal Transfer': InternalTransferScreen(),
    'Bank Transfer': InternalTransferScreen(),
    'Card Payment': InternalTransferScreen(),
    'Instant Transfer': InternalTransferScreen(),
  };

  // Transfer options for the dialog
  final List<Map<String, dynamic>> transferOptions = [
    {
      'label': 'Internal Transfer',
      'icon': Icons.account_balance_wallet,
      'screen': InternalTransferScreen(),
    },
    {
      'label': 'Bank Transfer',
      'icon': Icons.account_balance,
      'screen': BankTransfer(),
    },
    {
      'label': 'Card Payment',
      'icon': Icons.credit_card,
      'screen': CardPaymentScreen(),
    },
    {
      'label': 'Instant Transfer',
      'icon': Icons.account_balance_outlined,
      'screen': InstantTransferScreen(),
    },
    {
      'label': 'Explore Travel',
      'icon': Icons.airplanemode_active,
      'screen': TravelWelcomeScreen(),
    },
    {
      'label': 'Digital Wallets',
      'icon': Icons.account_balance_wallet_outlined,
      'screen': MyWalletScreen(),
    },
    {
      'label': 'Scan QR',
      'icon': Icons.qr_code_scanner,
      'action': 'scanQR', // Custom action for QR scanning
    },
  ];

  final List<Map<String, dynamic>> UtilityBiilsOptions = [
    {'label': 'MyFavourite', 'icon': Icons.star},
    {'label': 'Electricity', 'icon': Icons.power},
    {'label': 'Gas', 'icon': Icons.gas_meter},
    {'label': 'Water', 'icon': Icons.water_drop},
    {'label': 'Internet', 'icon': Icons.network_wifi_3_bar_rounded},
    {'label': 'Telephone', 'icon': Icons.phone},
  ];

  final List<Map<String, dynamic>> paymentOptions = [
    {'label': 'UPI', 'icon': Icons.payment},
    {'label': 'Credit/Debit Card', 'icon': Icons.credit_card},
    {'label': 'Net Banking', 'icon': Icons.account_balance},
    {'label': 'Digital Wallets', 'icon': Icons.account_balance_wallet},
  ];

  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  bool _imagesPrecached = false;
  String? _userName;
  bool _isLoading = true;
  String? _errorMessage;
  String? _profilePicUrl;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isBalanceVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchProfilePic();
  }

  Future<void> _fetchProfilePic() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (userDoc.exists && userDoc.data()?['ProfilePic'] != null) {
        setState(() {
          _profilePicUrl = userDoc.data()?['ProfilePic'];
        });
      }
    } catch (e) {
      print("❌ Error fetching profile pic: $e");
    }
  }

  Future<void> _fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'No user logged in';
          _isLoading = false;
        });
        return;
      }

      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (userDoc.exists) {
        setState(() {
          _userName = userDoc.data()?['username'] ?? 'Guest';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'User data not found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching user data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    await _fetchUserName();
    await _fetchProfilePic();
  }

  Future<void> _handleLogout() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Logout'),
            content: Text('Are you sure you want to log out?'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'No',
                  style: TextStyle(color: ColorsField.buttonRed),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Yes', style: TextStyle(color: Color(0xFF2A5C54))),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        print("❌ Error logging out: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error logging out: $e')));
      }
    }
  }

  // New method to handle QR code scanning
  void _scanQRCode() async {
    Navigator.pop(context); // Close the bottom sheet
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => QRScannerScreen()),
    );
  }

  void _showTransferDialog() {
    showModalBottomSheet(
      backgroundColor: ColorsField.backgroundLight,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Send Money to',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 40),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                crossAxisSpacing: 8,
                mainAxisSpacing: 30,
                childAspectRatio: 0.8,
                physics: NeverScrollableScrollPhysics(),
                children:
                    transferOptions.map((option) {
                      return GestureDetector(
                        onTap: () {
                          if (option['action'] == 'scanQR') {
                            _scanQRCode(); // Handle QR scan
                          } else if (option['screen'] != null) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => option['screen'],
                              ),
                            );
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${option['label']} selected'),
                              ),
                            );
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  option['icon'],
                                  size: 30,
                                  color: ColorsField.buttonRed,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              option['label'],
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showUtilityBillsDialouge() {
    showModalBottomSheet(
      backgroundColor: ColorsField.backgroundLight,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Utility Bills',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 40),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                crossAxisSpacing: 8,
                mainAxisSpacing: 30,
                childAspectRatio: 0.8,
                physics: NeverScrollableScrollPhysics(),
                children:
                    UtilityBiilsOptions.map((option) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${option['label']} selected'),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  option['icon'],
                                  size: 35,
                                  color: ColorsField.buttonRed,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              option['label'],
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentDialog() {
    showModalBottomSheet(
      backgroundColor: ColorsField.backgroundLight,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Payment Options',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                crossAxisSpacing: 8,
                mainAxisSpacing: 20,
                childAspectRatio: 0.8,
                physics: NeverScrollableScrollPhysics(),
                children:
                    paymentOptions.map((option) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${option['label']} selected'),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  option['icon'],
                                  size: 35,
                                  color: ColorsField.buttonRed,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              option['label'],
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPrecached) {
      for (var card in cards) {
        precacheImage(AssetImage(card['imageUrl']!), context);
      }
      precacheImage(AssetImage('assets/images/placeholder.png'), context);
      _imagesPrecached = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: Color(0xFFFF5733),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: GestureDetector(
                          onTap: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          child: Icon(Icons.menu, size: 35),
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => Notifications(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.notifications,
                              color: ColorsField.buttonRed,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 25),
                           GestureDetector(
                            onTap: () {
                              _handleLogout();
                            },
                            child: Icon(
                              Icons.logout,
                              color: ColorsField.buttonRed,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 25),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ProfilePage(),
                                ),
                              );
                            },

                            child: CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.grey[300],
                              backgroundImage:
                                  _profilePicUrl != null
                                      ? NetworkImage(_profilePicUrl!)
                                      : null,
                              child:
                                  _profilePicUrl == null
                                      ? Icon(Icons.person, color: Colors.white)
                                      : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            _isLoading
                                ? SpinKitThreeBounce(
                                  color: ColorsField.buttonRed,
                                  size: 30,
                                )
                                : Row(
                                  children: [
                                    Text(
                                      'Welcome,',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    _errorMessage != null
                                        ? Text(
                                          _errorMessage!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                          ),
                                        )
                                        : Text(
                                          _userName ?? 'Guest',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  ],
                                ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          height: 200.0,
                          autoPlay: false,
                          autoPlayInterval: Duration(seconds: 5),
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items:
                            cards.map((card) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF1E3A8A),
                                            Color.fromARGB(255, 255, 255, 255),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          stops: [0.6, 0.4],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Balance',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          _isBalanceVisible
                                                              ? '₹ 562554.29'
                                                              : '••••••••••••',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _isBalanceVisible =
                                                                  !_isBalanceVisible;
                                                            });
                                                          },
                                                          child: Icon(
                                                            _isBalanceVisible
                                                                ? Icons
                                                                    .visibility
                                                                : Icons
                                                                    .visibility_off,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Account Number',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      '**** **** **** 6563',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Image.asset(
                                                  'assets/images/WealthLet.png',
                                                  height: 25,
                                                  alignment: Alignment.topLeft,
                                                ),
                                                SizedBox(height: 20),
                                                Image.asset(
                                                  'assets/images/chip.png',
                                                  height: 35,
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: [
                      _buildActionButton(
                        Icons.send,
                        'Transfer',
                        Color(0xFF2A5C54),
                        onTap: _showTransferDialog,
                      ),
                      _buildActionButton(
                        Icons.payment,
                        'Payment',
                        Color(0xFFFF5733),
                        onTap: _showPaymentDialog,
                      ),
                      _buildActionButton(
                        Icons.receipt,
                        'Pay Bill',
                        Color(0xFF4682B4),
                        onTap: _showUtilityBillsDialouge,
                      ),
                      _buildActionButton(
                        Icons.schedule,
                        'Scheduled',
                        Color(0xFF6A5ACD),
                        onTap: () async {
                          // Show the customized date picker dialog
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.now(), // Today's date: May 29, 2025
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  // Customize the overall dialog shape and background using DialogThemeData
                                  dialogTheme: DialogThemeData(
                                    // Changed from DialogTheme to DialogThemeData
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 8,
                                    backgroundColor: Colors.white,
                                  ),
                                  // Customize the color scheme
                                  colorScheme: ColorScheme.light(
                                    primary:
                                        ColorsField
                                            .buttonRed, // Header background color
                                    onPrimary:
                                        Colors.white, // Header text color
                                    surface: ColorsField.backgroundLight,
                                    // Background of the date picker body
                                    onSurface:
                                        Colors.black87, // Text color for dates
                                  ),
                                  // Customize the text styles
                                  textTheme: TextTheme(
                                    headlineMedium: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ), // Header text (e.g., "May 2025")
                                    bodyMedium: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ), // Dates text
                                  ),
                                  // Customize the buttons (OK, Cancel)
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                          ColorsField
                                              .buttonRed, // Button text color
                                      textStyle: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  // Customize the day cells
                                  buttonTheme: ButtonThemeData(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          // Handle the selected date
                          if (selectedDate != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Selected date: ${selectedDate.toString().split(' ')[0]}',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'MY SWIFTT',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF5733),
                                ),
                              ),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2A5C54),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          GridView.count(
                            crossAxisCount: 4,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.8,
                            children: [
                              _buildActionButton(
                                Icons.savings,
                                'Savings',
                                Color(0xFF2A5C54),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Savings selected')),
                                  );
                                },
                              ),
                              _buildActionButton(
                                Icons.local_offer,
                                'Offer',
                                Color(0xFFFF5733),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Offer selected')),
                                  );
                                },
                              ),
                              _buildActionButton(
                                Icons.schedule,
                                'Scheduled',
                                Color(0xFF4682B4),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Scheduled selected'),
                                    ),
                                  );
                                },
                              ),
                              _buildActionButton(
                                Icons.send,
                                'Remittance',
                                Color(0xFF6A5ACD),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Remittance selected'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          GridView.count(
                            crossAxisCount: 4,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.8,
                            children: [
                              _buildActionButton(
                                Icons.arrow_upward,
                                'Topup',
                                Color(0xFF2A5C54),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Topup selected')),
                                  );
                                },
                              ),
                              _buildActionButton(
                                Icons.trending_up,
                                'Invest',
                                Color(0xFFFF5733),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Invest selected')),
                                  );
                                },
                              ),
                              _buildActionButton(
                                Icons.favorite,
                                'Donation',
                                Color(0xFF4682B4),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Donation selected'),
                                    ),
                                  );
                                },
                              ),
                              _buildActionButton(
                                Icons.account_balance,
                                'Loan',
                                Color(0xFF6A5ACD),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Loan selected')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: ColorsField.buttonRed),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      _profilePicUrl != null
                          ? NetworkImage(_profilePicUrl!)
                          : null,
                  child:
                      _profilePicUrl == null
                          ? Icon(Icons.person, color: Colors.white, size: 40)
                          : null,
                ),
                SizedBox(height: 10),
                Text(
                  _userName ?? 'Guest',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  FirebaseAuth.instance.currentUser?.email ?? '',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Color(0xFFFF5733)),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Color(0xFFFF5733)),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: Color(0xFFFF5733)),
            title: Text('Transactions'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Transactions page not implemented')),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Color(0xFFFF5733)),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Settings page not implemented')),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: ColorsField.buttonRed),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              _handleLogout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(child: Icon(icon, color: iconColor, size: 28)),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

// New QR Scanner Screen
class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  bool _isScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan QR Code',
          style: TextStyle(color: ColorsField.backgroundLight),
        ),
        backgroundColor: ColorsField.buttonRed,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorsField.backgroundLight),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (!_isScanned) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    setState(() {
                      _isScanned = true;
                    });
                    // Handle the scanned QR code data
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('QR Code Scanned: ${barcode.rawValue}'),
                      ),
                    );
                    // Optionally navigate back or to another screen with the scanned data
                    Navigator.pop(context);
                    break;
                  }
                }
              }
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: ColorsField.buttonRed, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: FloatingActionButton(
              backgroundColor: ColorsField.buttonRed,
              onPressed: () {
                controller.toggleTorch();
              },
              child: ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, state, child) {
                  return Icon(
                    state == TorchState.off ? Icons.flash_off : Icons.flash_on,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
