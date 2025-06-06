import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';
import 'package:wealthlet/core/services/notifications.dart';
import 'package:wealthlet/features/Auth/Presentation/Screens/Login.dart';
import 'package:wealthlet/features/Home/Presentation/Widgets/DonationScreen.dart';
import 'package:wealthlet/features/Home/Presentation/Widgets/InvestScreen.dart';
import 'package:wealthlet/features/Home/Presentation/Widgets/LoanScreen.dart';
import 'package:wealthlet/features/Home/Presentation/Widgets/OffersPage.dart';
import 'package:wealthlet/features/Home/Presentation/Widgets/RemittanceScreen.dart';
import 'package:wealthlet/features/Home/Presentation/Widgets/Savings.dart';
import 'package:wealthlet/features/Home/Presentation/Widgets/Schedule_Transaction.dart';
import 'package:wealthlet/features/Home/Presentation/Widgets/TopUpScreen.dart';
import 'package:wealthlet/features/Payments/Presentation/Screens/BankTransfer.dart';
import 'package:wealthlet/features/Payments/Presentation/Screens/CardPayment.dart';
import 'package:wealthlet/features/Payments/Presentation/Screens/ElectricityPayment.dart';
import 'package:wealthlet/features/Payments/Presentation/Screens/InstantTransfer.dart';
import 'package:wealthlet/features/Payments/Presentation/Screens/InternalTransfer.dart';
import 'package:wealthlet/features/Payments/Presentation/Screens/WalletScreens.dart';
import 'package:wealthlet/features/Payments/Presentation/Widgets/balance_display.dart';
import 'package:wealthlet/features/Profile/Presentation/Screens/profile.dart';
import 'package:wealthlet/features/Travel/Presentation/Screens/TravelWelcomeScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wealthlet/features/Payments/Bloc/InternalTransferBloc/internal_transfer_bloc.dart';
import 'package:wealthlet/features/Payments/Bloc/InternalTransferBloc/internal_transfer_event.dart';
import 'package:wealthlet/features/Payments/Bloc/InternalTransferBloc/internal_transfer_state.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Map<String, String>> cards = [
    {'number': '**** **** **** 1234', 'imageUrl': 'assets/images/card1.jpg'},
  ];

  final Map<String, Widget> routeMap = {
    'Internal Transfer': InternalTransferScreen(),
    'Bank Transfer': InternalTransferScreen(),
    'Card Payment': InternalTransferScreen(),
    'Instant Transfer': InternalTransferScreen(),
  };

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
    {'label': 'Scan QR', 'icon': Icons.qr_code_scanner, 'action': 'scanQR'},
  ];

  final List<Map<String, dynamic>> UtilityBiilsOptions = [
    {'label': 'MyFavourite', 'icon': Icons.star},
    {
      'label': 'Electricity',
      'icon': Icons.power,
      'screen': ElectricityBoardScreen(),
    },
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

  Future<void> _handleRefresh(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _userName = null;
      _profilePicUrl = null;
    });

    await Future.wait([_fetchUserName(), _fetchProfilePic()]);

    context.read<InternalTransferBloc>().add(FetchAccountsEvent());

    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      _isLoading = false;
    });
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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false);
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const LoginScreen()),
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

  void _scanQRCode() async {
    Navigator.pop(context);
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
                            _scanQRCode();
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
                          if (option['screen'] != null) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => option['screen'],
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ElectricityBoardScreen(),
                              ),
                            );
                          }
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

  Widget _buildSkeletonLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(width: 35, height: 35, color: Colors.white),
                  Spacer(),
                  Row(
                    children: [
                      Container(width: 28, height: 28, color: Colors.white),
                      SizedBox(width: 25),
                      Container(width: 28, height: 28, color: Colors.white),
                      SizedBox(width: 25),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
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
                  Row(
                    children: [
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          width: 250,
                          height: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
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
                children: List.generate(4, (index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(width: 40, height: 12, color: Colors.white),
                    ],
                  );
                }),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(width: 80, height: 16, color: Colors.white),
                          Container(width: 40, height: 14, color: Colors.white),
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
                        children: List.generate(8, (index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                width: 40,
                                height: 12,
                                color: Colors.white,
                              ),
                            ],
                          );
                        }),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              InternalTransferBloc(FlutterLocalNotificationsPlugin())
                ..add(FetchAccountsEvent()),
      child: Builder(
        builder:
            (newContext) => Scaffold(
              key: _scaffoldKey,
              drawer: _buildDrawer(),
              body:
                  _isLoading
                      ? _buildSkeletonLoader()
                      : SafeArea(
                        child: RefreshIndicator(
                          onRefresh: () => _handleRefresh(newContext),
                          color: Color(0xFFFF5733),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            _scaffoldKey.currentState
                                                ?.openDrawer();
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
                                                CupertinoPageRoute<void>(
                                                  builder:
                                                      (context) =>
                                                          Notifications(),
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
                                            onTap: _handleLogout,
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
                                                CupertinoPageRoute<void>(
                                                  builder:
                                                      (context) =>
                                                          ProfilePage(),
                                                ),
                                              );
                                            },
                                            child: CircleAvatar(
                                              radius: 26,
                                              backgroundColor: Colors.grey[300],
                                              backgroundImage:
                                                  _profilePicUrl != null
                                                      ? NetworkImage(
                                                        _profilePicUrl!,
                                                      )
                                                      : null,
                                              child:
                                                  _profilePicUrl == null
                                                      ? Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                      )
                                                      : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Row(
                                          children: [
                                            _errorMessage != null
                                                ? Text(
                                                  _errorMessage!,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red,
                                                  ),
                                                )
                                                : Row(
                                                  children: [
                                                    Text(
                                                      'Welcome,',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      _userName ?? 'Guest',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                          autoPlayInterval: Duration(
                                            seconds: 5,
                                          ),
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
                                                builder: (
                                                  BuildContext context,
                                                ) {
                                                  return Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            Color(0xFF1E3A8A),
                                                            Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255,
                                                            ),
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end:
                                                              Alignment
                                                                  .bottomRight,
                                                          stops: [0.6, 0.4],
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              16.0,
                                                            ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Balance',
                                                                      style: TextStyle(
                                                                        color:
                                                                            Colors.white,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        _isBalanceVisible
                                                                            ? BalanceDisplay(
                                                                              accountType:
                                                                                  'source',
                                                                              balanceTextStyle: TextStyle(
                                                                                color:
                                                                                    Colors.white,
                                                                                fontSize:
                                                                                    20,
                                                                                fontWeight:
                                                                                    FontWeight.bold,
                                                                              ),
                                                                              errorTextStyle: TextStyle(
                                                                                color:
                                                                                    Colors.red,
                                                                                fontSize:
                                                                                    16,
                                                                              ),
                                                                            )
                                                                            : Text(
                                                                              '••••••••••••',
                                                                              style: TextStyle(
                                                                                color:
                                                                                    Colors.white,
                                                                                fontSize:
                                                                                    20,
                                                                                fontWeight:
                                                                                    FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                        SizedBox(
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            setState(() {
                                                                              _isBalanceVisible =
                                                                                  !_isBalanceVisible;
                                                                            });
                                                                          },
                                                                          child: Icon(
                                                                            _isBalanceVisible
                                                                                ? Icons.visibility
                                                                                : Icons.visibility_off,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                20,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Account Number',
                                                                      style: TextStyle(
                                                                        color:
                                                                            Colors.white,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Text(
                                                                      card['number']!,
                                                                      style: TextStyle(
                                                                        color:
                                                                            Colors.white,
                                                                        fontSize:
                                                                            14,
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
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Image.asset(
                                                                  'assets/images/WealthLet.png',
                                                                  height: 25,
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Image.asset(
                                                                  'assets/images/chip.png',
                                                                  height: 35,
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomLeft,
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
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
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute<void>(
                                              builder:
                                                  (context) =>
                                                      ScheduledTransactionsScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                  fontSize: 14,
                                                  color: Color(0xFF2A5C54),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          GridView.count(
                                            crossAxisCount: 4,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                            childAspectRatio: 0.8,
                                            children: [
                                              _buildActionButton(
                                                Icons.savings,
                                                'Savings',
                                                Color(0xFF2A5C54),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder:
                                                          (context) =>
                                                              SavingsScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                              _buildActionButton(
                                                Icons.local_offer,
                                                'Offer',
                                                Color(0xFFFF5733),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder:
                                                          (context) =>
                                                              OfferScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                              _buildActionButton(
                                                Icons.schedule,
                                                'Scheduled',
                                                Color(0xFF4682B4),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute<void>(
                                                      builder:
                                                          (context) =>
                                                              ScheduledTransactionsScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                              _buildActionButton(
                                                Icons.send,
                                                'Remittance',
                                                Color(0xFF6A5ACD),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute<void>(
                                                      builder:
                                                          (context) =>
                                                              RemittanceScreen(),
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
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                            childAspectRatio: 0.8,
                                            children: [
                                              _buildActionButton(
                                                Icons.arrow_upward,
                                                'Topup',
                                                Color(0xFF2A5C54),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute<void>(
                                                      builder:
                                                          (context) =>
                                                              TopupScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                              _buildActionButton(
                                                Icons.trending_up,
                                                'Invest',
                                                Color(0xFFFF5733),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute<void>(
                                                      builder:
                                                          (context) =>
                                                              InvestScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                              _buildActionButton(
                                                Icons.favorite,
                                                'Donation',
                                                Color(0xFF4682B4),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute<void>(
                                                      builder:
                                                          (context) =>
                                                              DonationScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                              _buildActionButton(
                                                Icons.account_balance,
                                                'Loan',
                                                Color(0xFF6A5ACD),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute<void>(
                                                      builder:
                                                          (context) =>
                                                              LoanScreen(),
                                                    ),
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
            leading: Icon(Icons.network_wifi, color: Color(0xFFFF5733)),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Color(0xFFFF5733)),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(
                context,
                CupertinoPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: Color(0xFFFF5733)),
            title: Text('Payments'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payments page not found')),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Color(0xFFFF5733)),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Settings page not found')),
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
            child: Center(child: Icon(icon, size: 28, color: iconColor)),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

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
          icon: Icon(Icons.arrow_back_ios, color: ColorsField.backgroundLight),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('QR Code Scanned: ${barcode.rawValue}'),
                      ),
                    );
                    Navigator.pop(context);
                    break;
                  }
                } // Missing closing brace for the for loop
              } // Closing brace for if
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
                builder: (context, value, child) {
                  return Icon(
                    value.torchState == TorchState.off
                        ? Icons.flash_off
                        : Icons.flash_on,
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
