import 'package:flutter/material.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';

class DonationScreen extends StatefulWidget {
  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  // Form controllers
  final _amountController = TextEditingController();

  // NGO/Cause selection state
  String selectedCause = 'Education';
  List<String> causes = ['Education', 'Healthcare', 'Environment', 'Child Welfare'];

  // Payment method selection state
  String selectedPaymentMethod = 'UPI';
  List<String> paymentMethods = ['UPI', 'Savings Account', 'Debit Card'];

  // Recurring donation toggle
  bool isRecurring = false;

  // Donation history
  final List<Map<String, dynamic>> donationHistory = [
    {
      'cause': 'Education',
      'amount': '₹500',
      'date': '03 Jun 2025, 04:00 PM',
      'recurring': false,
      'receiptId': 'REC12345',
    },
    {
      'cause': 'Healthcare',
      'amount': '₹1000',
      'date': '01 Jun 2025, 10:30 AM',
      'recurring': true,
      'receiptId': 'REC12346',
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // Function to handle donation
  void donate() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }
    setState(() {
      donationHistory.insert(0, {
        'cause': selectedCause,
        'amount': '₹${_amountController.text}',
        'date': '03 Jun 2025, 04:06 PM',
        'recurring': isRecurring,
        'receiptId': 'REC${DateTime.now().millisecondsSinceEpoch}',
      });
      _amountController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Donation successful!')),
    );
  }

  // Function to simulate tax receipt download
  void downloadReceipt(String receiptId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading receipt $receiptId...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

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
          'Donation',
          style: TextStyle(
            color: ColorsField.backgroundLight,
            fontSize: screenWidth * 0.05,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ColorsField.backgroundLight,
            size: screenWidth * 0.06,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Donation Form Section
              Text(
                'Make a Donation',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: ColorsField.blackColor,
                ),
              ),
              SizedBox(height: padding),
              // Cause Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Cause',
                    style: TextStyle(
                      fontSize: descriptionFontSize,
                      color: ColorsField.blackColor,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedCause,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCause = newValue!;
                      });
                    },
                    items: causes.map<DropdownMenuItem<String>>((String cause) {
                      return DropdownMenuItem<String>(
                        value: cause,
                        child: Text(
                          cause,
                          style: TextStyle(fontSize: smallFontSize),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: padding),
              // Donation Amount
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Enter Amount (₹)',
                  labelStyle: TextStyle(fontSize: descriptionFontSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                style: TextStyle(fontSize: descriptionFontSize),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: padding),
              // Recurring Donation Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Make this a monthly donation',
                    style: TextStyle(
                      fontSize: descriptionFontSize,
                      color: ColorsField.blackColor,
                    ),
                  ),
                  Switch(
                    value: isRecurring,
                    onChanged: (value) {
                      setState(() {
                        isRecurring = value;
                      });
                    },
                    activeColor: ColorsField.buttonRed,
                  ),
                ],
              ),
              SizedBox(height: padding),
              // Payment Method Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Payment Method',
                    style: TextStyle(
                      fontSize: descriptionFontSize,
                      color: ColorsField.blackColor,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedPaymentMethod,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPaymentMethod = newValue!;
                      });
                    },
                    items: paymentMethods.map<DropdownMenuItem<String>>((String method) {
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Text(
                          method,
                          style: TextStyle(fontSize: smallFontSize),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: padding),
              // Donate Button
              Center(
                child: ElevatedButton(
                  onPressed: donate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsField.buttonRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: padding * 2,
                      vertical: padding,
                    ),
                  ),
                  child: Text(
                    'Donate Now',
                    style: TextStyle(
                      color: ColorsField.backgroundLight,
                      fontSize: filterFontSize,
                    ),
                  ),
                ),
              ),
              SizedBox(height: padding * 2),
              // Donation History Section
              Text(
                'Donation History',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: ColorsField.blackColor,
                ),
              ),
              SizedBox(height: padding),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: donationHistory.length,
                itemBuilder: (context, index) {
                  final donation = donationHistory[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.025),
                    ),
                    child: ListTile(
                      title: Text(
                        donation['cause'] ?? 'Unknown',
                        style: TextStyle(
                          fontSize: descriptionFontSize,
                          color: ColorsField.blackColor,
                        ),
                      ),
                      subtitle: Text(
                        '${donation['date'] ?? 'Unknown Date'} - ${donation['amount'] ?? 'Unknown Amount'} ${donation['recurring'] == true ? '(Recurring)' : ''}',
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: ColorsField.blackColor.withOpacity(0.7),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.download,
                          size: smallFontSize,
                          color: ColorsField.buttonRed,
                        ),
                        onPressed: () => downloadReceipt(donation['receiptId'] ?? 'Unknown'),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}