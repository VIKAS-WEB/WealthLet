import 'package:flutter/material.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';

class RemittanceScreen extends StatefulWidget {
  @override
  _RemittanceScreenState createState() => _RemittanceScreenState();
}

class _RemittanceScreenState extends State<RemittanceScreen> {
  // Form controllers
  final _recipientNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscSwiftController = TextEditingController();
  final _amountController = TextEditingController();

  // Currency selection state
  String selectedCurrency = 'USD';
  List<String> currencies = ['USD', 'EUR', 'GBP', 'INR'];

  // Sample exchange rates (static for demo)
  Map<String, double> exchangeRates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.79,
    'INR': 83.5,
  };

  // Transfer amount state
  double transferAmount = 0.0;
  double fee = 0.0;
  double totalCost = 0.0;

  // Sample transaction history
  final List<Map<String, dynamic>> transactionHistory = [
    {
      'recipient': 'John Doe',
      'amount': '500 USD',
      'date': '01 Jun 2025',
      'status': 'Completed',
    },
    {
      'recipient': 'Priya Sharma',
      'amount': '20000 INR',
      'date': '30 May 2025',
      'status': 'Pending',
    },
  ];

  // Calculate fee and total cost
  void calculateTotal() {
    setState(() {
      transferAmount = double.tryParse(_amountController.text) ?? 0.0;
      fee = transferAmount * 0.02; // 2% fee for demo
      totalCost = transferAmount + fee;
    });
  }

  @override
  void initState() {
    super.initState();
    _amountController.addListener(calculateTotal);
  }

  @override
  void dispose() {
    _recipientNameController.dispose();
    _accountNumberController.dispose();
    _ifscSwiftController.dispose();
    _amountController.dispose();
    super.dispose();
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
          'Remittance',
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
                'Transfer Money',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: ColorsField.blackColor,
                ),
              ),
              SizedBox(height: padding),
              // Recipient Name
              TextField(
                controller: _recipientNameController,
                decoration: InputDecoration(
                  labelText: 'Recipient Name',
                  labelStyle: TextStyle(fontSize: descriptionFontSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                style: TextStyle(fontSize: descriptionFontSize),
              ),
              SizedBox(height: padding),
              // Account Number
              TextField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  labelStyle: TextStyle(fontSize: descriptionFontSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                style: TextStyle(fontSize: descriptionFontSize),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: padding),
              // IFSC/SWIFT Code
              TextField(
                controller: _ifscSwiftController,
                decoration: InputDecoration(
                  labelText: 'IFSC/SWIFT Code',
                  labelStyle: TextStyle(fontSize: descriptionFontSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                style: TextStyle(fontSize: descriptionFontSize),
              ),
              SizedBox(height: padding),
              // Currency Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Currency',
                    style: TextStyle(
                      fontSize: descriptionFontSize,
                      color: ColorsField.blackColor,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedCurrency,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCurrency = newValue!;
                        calculateTotal(); // Recalculate on currency change
                      });
                    },
                    items: currencies.map<DropdownMenuItem<String>>((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(
                          currency,
                          style: TextStyle(fontSize: smallFontSize),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: padding * 0.5),
              // Exchange Rate
              Text(
                'Exchange Rate: 1 $selectedCurrency = ${exchangeRates[selectedCurrency]! * (exchangeRates['INR'] ?? 1)} INR',
                style: TextStyle(
                  fontSize: smallFontSize,
                  color: ColorsField.blackColor.withOpacity(0.7),
                ),
              ),
              SizedBox(height: padding),
              // Transfer Amount
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Transfer Amount ($selectedCurrency)',
                  labelStyle: TextStyle(fontSize: descriptionFontSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                style: TextStyle(fontSize: descriptionFontSize),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: padding),
              // Fee and Total Cost Preview
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.025),
                ),
                child: Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fee: $fee $selectedCurrency (2%)',
                        style: TextStyle(
                          fontSize: descriptionFontSize,
                          color: ColorsField.blackColor,
                        ),
                      ),
                      SizedBox(height: padding * 0.5),
                      Text(
                        'Total Cost: $totalCost $selectedCurrency',
                        style: TextStyle(
                          fontSize: descriptionFontSize,
                          fontWeight: FontWeight.bold,
                          color: ColorsField.blackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: padding),
              // Transfer Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_recipientNameController.text.isEmpty ||
                        _accountNumberController.text.isEmpty ||
                        _ifscSwiftController.text.isEmpty ||
                        _amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all fields')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Transfer initiated!')),
                      );
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
                    'Transfer Now',
                    style: TextStyle(
                      color: ColorsField.backgroundLight,
                      fontSize: filterFontSize,
                    ),
                  ),
                ),
              ),
              SizedBox(height: padding * 2),
              // Transaction History Section
              Text(
                'Transaction History',
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
                itemCount: transactionHistory.length,
                itemBuilder: (context, index) {
                  final transaction = transactionHistory[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.025),
                    ),
                    child: ListTile(
                      title: Text(
                        transaction['recipient'] ?? 'Unknown',
                        style: TextStyle(
                          fontSize: descriptionFontSize,
                          color: ColorsField.blackColor,
                        ),
                      ),
                      subtitle: Text(
                        '${transaction['date'] ?? 'Unknown Date'} - ${transaction['amount'] ?? 'Unknown Amount'}',
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: ColorsField.blackColor.withOpacity(0.7),
                        ),
                      ),
                      trailing: Text(
                        transaction['status'] ?? 'Unknown',
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: transaction['status'] == 'Completed'
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