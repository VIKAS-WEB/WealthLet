import 'package:flutter/material.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';

class TopupScreen extends StatefulWidget {
  @override
  _TopupScreenState createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> {
  // Form controllers
  final _numberController = TextEditingController();
  final _amountController = TextEditingController();

  // Operator selection state
  String selectedOperator = 'Airtel';
  List<String> operators = ['Airtel', 'Jio', 'Vodafone', 'Dish TV'];

  // Payment method selection state
  String selectedPaymentMethod = 'Savings Account';
  List<String> paymentMethods = ['Savings Account', 'UPI', 'Debit Card'];

  // Predefined amounts
  List<int> predefinedAmounts = [100, 200, 500, 1000];

  // Top-up history
  final List<Map<String, dynamic>> topupHistory = [
    {
      'number': '9876543210',
      'operator': 'Airtel',
      'amount': '₹200',
      'date': '03 Jun 2025, 03:55 PM',
      'status': 'Completed',
    },
    {
      'number': '1234567890',
      'operator': 'Jio',
      'amount': '₹500',
      'date': '02 Jun 2025, 10:30 AM',
      'status': 'Pending',
    },
  ];

  @override
  void dispose() {
    _numberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Handle predefined amount selection
  void selectAmount(int amount) {
    setState(() {
      _amountController.text = amount.toString();
    });
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
          'Top-up',
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
              // Form Section
              Text(
                'Top-up Details',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: ColorsField.blackColor,
                ),
              ),
              SizedBox(height: padding),
              // Mobile Number / DTH ID
              TextField(
                controller: _numberController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number / DTH ID',
                  labelStyle: TextStyle(fontSize: descriptionFontSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                style: TextStyle(fontSize: descriptionFontSize),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: padding),
              // Operator Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Operator',
                    style: TextStyle(
                      fontSize: descriptionFontSize,
                      color: ColorsField.blackColor,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedOperator,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOperator = newValue!;
                      });
                    },
                    items: operators.map<DropdownMenuItem<String>>((String operator) {
                      return DropdownMenuItem<String>(
                        value: operator,
                        child: Text(
                          operator,
                          style: TextStyle(fontSize: smallFontSize),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: padding),
              // Amount Selection
              Text(
                'Select Amount',
                style: TextStyle(
                  fontSize: descriptionFontSize,
                  color: ColorsField.blackColor,
                ),
              ),
              SizedBox(height: padding * 0.5),
              Wrap(
                spacing: padding * 0.5,
                children: predefinedAmounts.map((amount) {
                  return ElevatedButton(
                    onPressed: () => selectAmount(amount),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsField.buttonRed.withOpacity(0.1),
                      foregroundColor: ColorsField.buttonRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: padding,
                        vertical: padding * 0.5,
                      ),
                    ),
                    child: Text(
                      '₹$amount',
                      style: TextStyle(fontSize: smallFontSize),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: padding),
              // Custom Amount Input
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Enter Custom Amount (₹)',
                  labelStyle: TextStyle(fontSize: descriptionFontSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                style: TextStyle(fontSize: descriptionFontSize),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              // Top-up Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_numberController.text.isEmpty || _amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all fields')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Top-up successful!')),
                      );
                      // Add to history (for demo)
                      setState(() {
                        topupHistory.insert(0, {
                          'number': _numberController.text,
                          'operator': selectedOperator,
                          'amount': '₹${_amountController.text}',
                          'date': '03 Jun 2025, 03:59 PM',
                          'status': 'Completed',
                        });
                      });
                      _numberController.clear();
                      _amountController.clear();
                    }
                  },
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
                    'Top-up Now',
                    style: TextStyle(
                      color: ColorsField.backgroundLight,
                      fontSize: filterFontSize,
                    ),
                  ),
                ),
              ),
              SizedBox(height: padding * 2),
              // Top-up History Section
              Text(
                'Top-up History',
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
                itemCount: topupHistory.length,
                itemBuilder: (context, index) {
                  final topup = topupHistory[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.025),
                    ),
                    child: ListTile(
                      title: Text(
                        topup['number'] ?? 'Unknown',
                        style: TextStyle(
                          fontSize: descriptionFontSize,
                          color: ColorsField.blackColor,
                        ),
                      ),
                      subtitle: Text(
                        '${topup['operator'] ?? 'Unknown'} - ${topup['date'] ?? 'Unknown Date'} - ${topup['amount'] ?? 'Unknown Amount'}',
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: ColorsField.blackColor.withOpacity(0.7),
                        ),
                      ),
                      trailing: Text(
                        topup['status'] ?? 'Unknown',
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: topup['status'] == 'Completed'
                              ? Colors.green
                              : Colors.orange,
                        ),
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