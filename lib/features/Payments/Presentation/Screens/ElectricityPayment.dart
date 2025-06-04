import 'package:flutter/material.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';

class ElectricityBoardScreen extends StatelessWidget {
  // List of electricity boards for the list view
  final List<Map<String, String>> electricityBoards = [
    {
      'icon': 'assets/images/Electricity/Arunachal.png',
      'name': 'ARPDOP - DEPARTMENT OF POWER, GOVERNMENT OF ARUNACHAL PRADESH',
    },
    {
      'icon': 'assets/images/Electricity/Arunachal.png',
      'name':
          'ARPDOP - DEPARTMENT OF POWER, GOVERNMENT OF ARUNACHAL PRADESH - Prepaid',
    },
    {
      'icon': 'assets/images/Electricity/Adani.png',
      'name': 'ADANI ELECTRICITY MUMBAI LIMITED',
    },
    {
      'icon': 'assets/images/Electricity/Ajmer.png',
      'name': 'AJMER VIDYUT VITRAN NIGAM Ltd - AVVNL',
    },
    {
      'icon': 'assets/images/Electricity/AndhraPradesh.png',
      'name': 'ANDHRA PRADESH CENTRAL POWER DISTRIBUTION CORPORATION LIMITED',
    },
    {
      'icon': 'assets/images/Electricity/Assam.png',
      'name': 'ASSAM POWER DISTRIBUTION COMPANY Ltd',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: ColorsField.backgroundLight)),
        title: Text(
          'Electricity Board',
          style: TextStyle(color: ColorsField.backgroundLight),
        ),
        backgroundColor: Colors.blue[900],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 22, 22, 22), ColorsField.buttonRed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Electricity Board',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            // Saved Connection Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'SAVED CONNECTION',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/Electricity/paschim.jpg',
                  ),
                ),
                title: Text(
                  'PASCHIMANCHAL VIDYUT VITRAN NIGAM LIMIT...',
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('985645231521'),
              ),
            ),
            // Advertisement Banner
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: EdgeInsets.all(16.0),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 91, 82, 82),
                    const Color.fromARGB(255, 234, 220, 220),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                color: ColorsField.buttonRed,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PAY BILLS VIA CREDIT CARD',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorsField.backgroundLight,
                          ),
                        ),
                        Text(
                          '@Lowest Convenience Fee',
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorsField.backgroundLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/Electricity/CreditCard.png',
                    width: 80,
                    height: 80,
                  ),
                ],
              ),
            ),
            // Electricity Boards Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                'ELECTRICITY BOARDS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: electricityBoards.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: ListTile(
                    leading: Image.asset(
                      electricityBoards[index]['icon']!,
                      width: 40,
                      height: 40,
                    ),
                    title: Text(
                      electricityBoards[index]['name']!,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_forward), label: ''),
        ],
      ),
    );
  }
}
