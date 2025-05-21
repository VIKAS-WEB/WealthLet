import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // List of card data for the carousel with different background images
  final List<Map<String, String>> cards = [
    {
      'number': '**** **** **** 1234',
      'imageUrl': 'assets/images/card1.jpg',
    },
    {
      'number': '**** **** **** 5678',
      'imageUrl': 'assets/images/card2.jpg',
    },
    {
      'number': '**** **** **** 9012',
      'imageUrl': 'assets/images/card3.jpg',
    },
  ];

  int _currentIndex = 0; // Track the current carousel index
  final CarouselSliderController _carouselController = CarouselSliderController();
  bool _imagesPrecached = false; // Flag to prevent redundant precaching

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache images only if not already done
    if (!_imagesPrecached) {
      for (var card in cards) {
        precacheImage(AssetImage(card['imageUrl']!), context);
      }
      precacheImage(AssetImage('assets/images/placeholder.jpg'), context); // Precache placeholder
        _imagesPrecached = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Profile and Balance
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 30,),
                  Text(
                    'Balance',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Row(
                    children: [
                     Icon(Icons.notifications, color: Colors.red, size: 28),
                    ],
                  ),
                  
                ],
              ),
            ),
            // Carousel Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  CarouselSlider(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      ),
                      items: cards.map((card) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: FadeInImage(
                                    placeholder: AssetImage('assets/images/placeholder.jpg'),
                                    image: AssetImage(card['imageUrl']!),
                                    fit: BoxFit.cover,
                                    imageErrorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/placeholder.jpg',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ).image,
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.3),
                                    BlendMode.darken,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'SWIFTT',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(
                                              Icons.credit_card,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          card['number']!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Image.network(
                                      'https://upload.wikimedia.org/wikipedia/commons/0/04/Mastercard-logo.png',
                                      height: 40,
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
                  // Carousel Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: cards.asMap().entries.map((entry) {
                      return GestureDetector(
                          onTap: () => _carouselController.jumpToPage(entry.key),
                          child: Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == entry.key
                                ? Color(0xFFFF5733)
                                : Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Action Buttons (Transfer, Payment, Pay Bill, Scheduled)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  _buildActionButton(Icons.send, 'Transfer', Color(0xFF2A5C54)),
                  _buildActionButton(Icons.payment, 'Payment', Color(0xFFFF5733)),
                  _buildActionButton(Icons.receipt, 'Pay Bill', Color(0xFF4682B4)),
                  _buildActionButton(Icons.schedule, 'Scheduled', Color(0xFF6A5ACD)),
                ],
              ),
            ),
            SizedBox(height: 16),
            // MY SWIFTT Section wrapped in a white container
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
                      // MY SWIFTT Section
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
                          _buildActionButton(Icons.savings, 'Savings', Color(0xFF2A5C54)),
                          _buildActionButton(Icons.local_offer, 'Offer', Color(0xFFFF5733)),
                          _buildActionButton(Icons.schedule, 'Scheduled', Color(0xFF4682B4)),
                          _buildActionButton(Icons.send, 'Remittance', Color(0xFF6A5ACD)),
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
                          _buildActionButton(Icons.arrow_upward, 'Topup', Color(0xFF2A5C54)),
                          _buildActionButton(Icons.trending_up, 'Invest', Color(0xFFFF5733)),
                          _buildActionButton(Icons.favorite, 'Donation', Color(0xFF4682B4)),
                          _buildActionButton(Icons.account_balance, 'Loan', Color(0xFF6A5ACD)),
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
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color iconColor) {
    return Column(
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
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}