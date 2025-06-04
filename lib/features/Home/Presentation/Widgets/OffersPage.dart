import 'package:flutter/material.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';

class OfferScreen extends StatefulWidget {
  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  // Sample data for offers with background images (nullable fields)
  final List<Map<String, dynamic>> offers = [
    {
      'title': '10% Cashback on Bill Payments',
      'description': 'Get 10% cashback on all bill payments above ₹500.',
      'category': 'Shopping',
      'expiry': '30 Jun 2025',
      'terms': 'Valid for first 1000 users. Minimum transaction ₹500.',
      'bgImage': 'https://media.istockphoto.com/id/623205372/photo/man-is-shopping-online-with-laptop.jpg?s=612x612&w=0&k=20&c=yDb2AKQKR53bO1FtfVgDH9OREQpYGjMJdza-PqaXXXQ=',
    },
    {
      'title': '20% Off on Travel Bookings',
      'description': 'Book flights or hotels and get 20% off.',
      'category': 'Travel',
      'expiry': '15 Jul 2025',
      'terms': 'Applicable on bookings via app only.',
      'bgImage': 'https://img.freepik.com/free-vector/flat-design-travel-background_23-2149193475.jpg?semt=ais_hybrid&w=740',
    },
    {
      'title': '15% Discount on Dining',
      'description': 'Dine at partner restaurants and save 15%.',
      'category': 'Dining',
      'expiry': '10 Jul 2025',
      'terms': 'Valid on weekends only.',
      'bgImage': 'https://img.freepik.com/free-photo/top-view-hamburger-with-copy-space_23-2148575421.jpg',
    },
  ];

  // Filter state
  String selectedCategory = 'All';
  List<String> categories = ['All', 'Shopping', 'Travel', 'Dining'];

  // Filtered offers based on category
  List<Map<String, dynamic>> get filteredOffers {
    if (selectedCategory == 'All') return offers;
    return offers.where((offer) => (offer['category'] ?? '') == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Define responsive font sizes
    double titleFontSize = screenWidth * 0.045; // Approx 18 on 400px width
    double descriptionFontSize = screenWidth * 0.035; // Approx 14
    double smallFontSize = screenWidth * 0.03; // Approx 12
    double filterFontSize = screenWidth * 0.04; // Approx 16

    // Define responsive padding
    double padding = screenWidth * 0.04; // Approx 16 on 400px width
    double cardPadding = screenWidth * 0.03; // Approx 12

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
          'Offers',
          style: TextStyle(
            color: ColorsField.backgroundLight,
            fontSize: screenWidth * 0.05, // Responsive AppBar title
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ColorsField.backgroundLight,
            size: screenWidth * 0.06, // Responsive icon size
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Filter Section
              Padding(
                padding: EdgeInsets.all(padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter by Category',
                      style: TextStyle(
                        fontSize: filterFontSize,
                        fontWeight: FontWeight.bold,
                        color: ColorsField.blackColor,
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                      items: categories.map<DropdownMenuItem<String>>((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: TextStyle(fontSize: smallFontSize),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              // Offers List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(padding),
                  itemCount: filteredOffers.length,
                  itemBuilder: (context, index) {
                    final offer = filteredOffers[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: padding * 0.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(screenWidth * 0.025),
                        image: DecorationImage(
                          image: NetworkImage(
                            offer['bgImage'] ?? 'https://previews.123rf.com/images/blankstock/blankstock2211/blankstock221102400/194845334-sunburst-ray-beam-banner-special-offer-liquid-shape-discount-sticker-banner-sale-coupon-icon.jpg',
                          ),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4), // Adjusted opacity for better readability
                            BlendMode.colorDodge, // Changed to darken for better contrast
                          ),
                        ),
                      ),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.025),
                        ),
                        color: Colors.transparent, // Transparent to show background image
                        child: Padding(
                          padding: EdgeInsets.all(cardPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Offer Title and Category
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      offer['title'] ?? 'Untitled Offer',
                                      style: TextStyle(
                                        fontSize: titleFontSize,
                                        fontWeight: FontWeight.bold,
                                        color: ColorsField.blackColor,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.5),
                                            offset: Offset(1, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: cardPadding * 0.5,
                                      vertical: cardPadding * 0.2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorsField.blackColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                                    ),
                                    child: Text(
                                      offer['category'] ?? 'General',
                                      style: TextStyle(
                                        color: ColorsField.blackColor,
                                        fontSize: smallFontSize,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: padding * 0.5),
                              // Offer Description
                              Text(
                                offer['description'] ?? 'No description available.',
                                style: TextStyle(
                                  fontSize: descriptionFontSize,
                                  color: ColorsField.blackColor.withOpacity(0.9),
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: padding * 0.5),
                              // Expiry Date
                              Text(
                                'Expires on: ${offer['expiry'] ?? 'Not specified'}',
                                style: TextStyle(
                                  fontSize: smallFontSize,
                                  color: ColorsField.blackColor.withOpacity(0.8),
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: padding * 0.8),
                              // Terms & Conditions (Expandable)
                             
                              SizedBox(height: padding * 0.5),
                              // Redeem Button
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Redeem tapped for ${offer['title'] ?? 'Untitled Offer'}')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorsField.buttonRed,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: padding,
                                      vertical: padding * 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    'Redeem',
                                    style: TextStyle(
                                      color: ColorsField.backgroundLight,
                                      fontSize: filterFontSize,
                                    ),
                                  ),
                                ),
                              ),
                               ExpansionTile(
                                title: Text(
                                  'Terms & Conditions',
                                  style: TextStyle(
                                    fontSize: descriptionFontSize,
                                    color: ColorsField.blackColor,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.5),
                                        offset: Offset(1, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: cardPadding,
                                      vertical: cardPadding * 0.5,
                                    ),
                                    child: Text(
                                      offer['terms'] ?? 'No terms available.',
                                      style: TextStyle(
                                        fontSize: smallFontSize,
                                        fontWeight: FontWeight.bold,
                                        color: ColorsField.backgroundLight,
                                        shadows: [
                                          Shadow(
                                            color: Colors.white,
//offset: Offset(1, 1),
                                            blurRadius: 0,
                                          ),
                                        ],
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
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}