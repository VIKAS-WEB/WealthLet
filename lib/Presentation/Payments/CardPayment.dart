import 'package:flutter/material.dart';
import 'package:wealthlet/utils/Colorfields.dart';

class CardPaymentScreen extends StatelessWidget {
  const CardPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        leading: InkWell(
          onTap: (){
          Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white)),
          title: Text(
          'Card Payment',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Updated Credit Card Section with Background Image
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/Card.jpg',
                  ), // Path to your background image
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // VISA Logo
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset('assets/images/MasterCard.png', width: 32,)
                    ),
                  ),
                  // Chip
                  Positioned(
                    top: 50,
                    left: 20,
                    child: Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/images/chip.png',
                          ), // Path to your background image
                          fit: BoxFit.contain,
                        ),
                      ),
                     
                    ),
                  ),
                  // Balance and Card Number
                  Positioned(
                    top: 110,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "1234  2555  5654  3322",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                            
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "VIKAS SHARMA",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        
                      ],
                    ),
                  ),
                  Positioned(
                    top: 140,
                    left: 160,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      
                        const SizedBox(height: 8),
                        const Text(
                          "02 / 2028",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(Icons.currency_rupee, "Pending Amount"),
                _buildActionButton(Icons.payment, "Pay Amount"),
              ],
            ),
            const SizedBox(height: 24),
            // History Section
            const Text(
              "History",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildHistoryItem(
                    icon: Icons.fastfood,
                    title: "Uber Eats",
                    subtitle: "Delivery",
                    amount: "-\$28.60",
                    isCredit: false,
                  ),
                  _buildHistoryItem(
                    icon: Icons.directions_car,
                    title: "Lyft",
                    subtitle: "Transport",
                    amount: "-\$8.60",
                    isCredit: false,
                  ),
                  _buildHistoryItem(
                    icon: Icons.apple,
                    title: "Apple Store",
                    subtitle: "Electronics",
                    amount: "-\$390.99",
                    isCredit: false,
                  ),
                  const Divider(),
                  _buildHistoryItem(
                    icon: Icons.credit_card,
                    title: "",
                    subtitle: "Credit Card",
                    amount: "-\$329.29",
                    isCredit: false,
                    date: "19 September",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //escaping: false,
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: Colors.grey[600]),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required bool isCredit,
    String? date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (date != null)
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCredit ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
