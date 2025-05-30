import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wealthlet/features/Home/Presentation/Screens/HomeScreen.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';

class TravelDashboard extends StatelessWidget {
  const TravelDashboard({super.key});

  // Simulate a refresh function
  Future<void> _onRefresh() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen()));
            },
            child: Icon(Icons.home, color: Colors.white),
          ),
          title: Text(
            'Travel The World With Wealthlet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 159, 64, 226), ColorsField.buttonRed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top navigation tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 30.0),
                child: TabBar(
                  isScrollable: true,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.pink,
                  tabs: [
                    Tab(text: "Popular"),
                    Tab(text: "Feature"),
                    Tab(text: "Offer"),
                    Tab(text: "Asia"),
                    Tab(text: "Europe"),
                    Tab(text: "Africa"),
                    Tab(text: "New"),
                  ],
                ),
              ),
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              // Icon row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconButton(Icons.home, Colors.pink[500]!,),
                    _buildIconButton(Icons.restaurant, Colors.pink[100]!),
                    _buildIconButton(Icons.flight, Colors.pink[100]!),
                    _buildIconButton(Icons.calendar_today, Colors.pink[100]!),
                  ],
                ),
              ),
              // Best Experiences title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Text(
                  "Best Experiences",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              // Cards section with pull-to-refresh
              Expanded(
                child: RefreshIndicator(
                  color: ColorsField.buttonRed,
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(), // Ensures scrollability for pull-to-refresh
                    child: Column(
                      children: [
                        // Row of two cards
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(child: _buildCard("assets/images/AwesomePlace.jpg", "Awesome Place")),
                              SizedBox(width: 16),
                              Expanded(child: _buildCard("assets/images/HotAirBaloon.jpg", "Awesome Place")),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        // Single card
                        _buildCardFullWidth("assets/images/Mountains.jpg", "Awesome Place"),
                        SizedBox(height: 16),
                        // Single card
                        _buildCardFullWidth("assets/images/SeaLand.jpg", "Awesome Place"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildCard(String imagePath, String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              imagePath,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) => Icon(Icons.star, size: 16, color: Colors.red)),
                ),
                SizedBox(height: 4),
                Text(
                  "Varius quam quisque id diam vel quam elementum.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFullWidth(String imagePath, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(15)),
              child: Image.asset(
                imagePath,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) => Icon(Icons.star, size: 16, color: Colors.red)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Varius quam quisque id diam vel quam elementum.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}