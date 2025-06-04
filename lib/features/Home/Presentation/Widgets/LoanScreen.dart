import 'package:flutter/material.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';
import 'dart:math';

class LoanScreen extends StatefulWidget {
  @override
  _LoanScreenState createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  // Active loans data (demo)
  final List<Map<String, dynamic>> activeLoans = [
    {
      'loanId': 'LN12345',
      'amount': 500000,
      'interestRate': 8.5,
      'emi': 10250,
      'tenure': 60,
      'remainingTenure': 48,
    },
    {
      'loanId': 'LN12346',
      'amount': 200000,
      'interestRate': 9.0,
      'emi': 4150,
      'tenure': 36,
      'remainingTenure': 24,
    },
  ];

  // Form controllers for new loan application
  final _loanAmountController = TextEditingController();
  final _purposeController = TextEditingController();
  final _tenureController = TextEditingController();

  // EMI calculator controllers
  final _emiAmountController = TextEditingController();
  final _emiTenureController = TextEditingController();
  final _emiInterestController = TextEditingController(text: '8.5');

  // Calculated EMI
  double calculatedEMI = 0.0;

  // Eligibility checker (demo data)
  double userIncome = 50000; // Monthly income (demo)
  double maxEligibleAmount = 0.0;

  // Repayment schedule for selected loan
  Map<String, dynamic>? selectedLoan;
  List<Map<String, dynamic>> repaymentSchedule = [];

  @override
  void initState() {
    super.initState();
    // Calculate eligibility on screen load
    calculateEligibility();
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    _purposeController.dispose();
    _tenureController.dispose();
    _emiAmountController.dispose();
    _emiTenureController.dispose();
    _emiInterestController.dispose();
    super.dispose();
  }

  // Calculate loan eligibility (demo logic)
  void calculateEligibility() {
    setState(() {
      maxEligibleAmount = userIncome * 36; // 3 years of monthly income
    });
  }

  // Calculate EMI
  void calculateEMI() {
    double principal = double.tryParse(_emiAmountController.text) ?? 0.0;
    double tenure = double.tryParse(_emiTenureController.text) ?? 0.0;
    double interestRate = double.tryParse(_emiInterestController.text) ?? 0.0;

    if (principal <= 0 || tenure <= 0 || interestRate <= 0) {
      setState(() {
        calculatedEMI = 0.0;
      });
      return;
    }

    double monthlyRate = interestRate / (12 * 100); // Monthly interest rate
    double emi = (principal * monthlyRate * pow(1 + monthlyRate, tenure)) /
        (pow(1 + monthlyRate, tenure) - 1);

    setState(() {
      calculatedEMI = emi;
    });
  }

  // Generate repayment schedule
  void generateRepaymentSchedule(Map<String, dynamic> loan) {
    List<Map<String, dynamic>> schedule = [];
    double remainingBalance = loan['amount'];
    double monthlyRate = loan['interestRate'] / (12 * 100);
    double emi = loan['emi'];
    DateTime currentDate = DateTime.now();

    for (int i = 1; i <= loan['remainingTenure']; i++) {
      double interest = remainingBalance * monthlyRate;
      double principal = emi - interest;
      remainingBalance -= principal;

      schedule.add({
        'month': '${currentDate.add(Duration(days: 30 * i)).toString().substring(0, 10)}',
        'emi': emi,
        'principal': principal,
        'interest': interest,
        'balance': remainingBalance < 0 ? 0 : remainingBalance,
      });
    }

    setState(() {
      repaymentSchedule = schedule;
      selectedLoan = loan;
    });
  }

  // Apply for new loan
  void applyLoan() {
    if (_loanAmountController.text.isEmpty ||
        _purposeController.text.isEmpty ||
        _tenureController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    double amount = double.tryParse(_loanAmountController.text) ?? 0.0;
    if (amount > maxEligibleAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Amount exceeds your eligibility')),
      );
      return;
    }

    setState(() {
      activeLoans.add({
        'loanId': 'LN${DateTime.now().millisecondsSinceEpoch}',
        'amount': amount,
        'interestRate': 8.5,
        'emi': amount * 0.0205, // Simplified EMI calculation for demo
        'tenure': int.tryParse(_tenureController.text) ?? 0,
        'remainingTenure': int.tryParse(_tenureController.text) ?? 0,
      });
      _loanAmountController.clear();
      _purposeController.clear();
      _tenureController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Loan application submitted!')),
    );
  }

  // Early repayment
  void earlyRepayment(Map<String, dynamic> loan) {
    setState(() {
      activeLoans.remove(loan);
      repaymentSchedule = [];
      selectedLoan = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Loan repaid early!')),
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
          'Loan',
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
              // Active Loans Section
              Text(
                'Active Loans',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: ColorsField.blackColor,
                ),
              ),
              SizedBox(height: padding),
              activeLoans.isEmpty
                  ? Text(
                      'No active loans.',
                      style: TextStyle(
                        fontSize: descriptionFontSize,
                        color: ColorsField.blackColor.withOpacity(0.7),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: activeLoans.length,
                      itemBuilder: (context, index) {
                        final loan = activeLoans[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.025),
                          ),
                          child: ExpansionTile(
                            title: Text(
                              'Loan ID: ${loan['loanId']}',
                              style: TextStyle(
                                fontSize: descriptionFontSize,
                                color: ColorsField.blackColor,
                              ),
                            ),
                            subtitle: Text(
                              'Amount: ₹${loan['amount']} | EMI: ₹${loan['emi']}',
                              style: TextStyle(
                                fontSize: smallFontSize,
                                color: ColorsField.blackColor.withOpacity(0.7),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(cardPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Interest Rate: ${loan['interestRate']}% p.a.',
                                      style: TextStyle(fontSize: smallFontSize),
                                    ),
                                    Text(
                                      'Tenure: ${loan['tenure']} months',
                                      style: TextStyle(fontSize: smallFontSize),
                                    ),
                                    Text(
                                      'Remaining Tenure: ${loan['remainingTenure']} months',
                                      style: TextStyle(fontSize: smallFontSize),
                                    ),
                                    SizedBox(height: padding),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => generateRepaymentSchedule(loan),
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
                                            'View Schedule',
                                            style: TextStyle(
                                              color: ColorsField.backgroundLight,
                                              fontSize: smallFontSize,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => earlyRepayment(loan),
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
                                            'Repay Early',
                                            style: TextStyle(
                                              color: ColorsField.backgroundLight,
                                              fontSize: smallFontSize,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              SizedBox(height: padding * 2),
              // Loan Eligibility Checker
              Text(
                'Loan Eligibility',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: ColorsField.blackColor,
                ),
              ),
              SizedBox(height: padding),
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
                        'Monthly Income: ₹$userIncome',
                        style: TextStyle(fontSize: descriptionFontSize),
                      ),
                      SizedBox(height: padding * 0.5),
                      Text(
                        'Eligible Loan Amount: ₹${maxEligibleAmount.toStringAsFixed(2)}',
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
              SizedBox(height: padding * 2),
              // Apply for New Loan
              Text(
                'Apply for New Loan',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: ColorsField.blackColor,
                ),
              ),
              SizedBox(height: padding),
              TextField(
                controller: _loanAmountController,
                decoration: InputDecoration(
                  labelText: 'Loan Amount (₹)',
                  labelStyle: TextStyle(fontSize: descriptionFontSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                style: TextStyle(fontSize: descriptionFontSize),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: padding),
              TextField(
                controller: _purposeController,
                decoration: InputDecoration(
                  labelText: 'Purpose of Loan',
                  labelStyle: TextStyle(fontSize: descriptionFontSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                style: TextStyle(fontSize: descriptionFontSize),
              ),
              SizedBox(height: padding),
              TextField(
                controller: _tenureController,
                decoration: InputDecoration(
                  labelText: 'Tenure (Months)',
                  labelStyle: TextStyle(fontSize: descriptionFontSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                style: TextStyle(fontSize: descriptionFontSize),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: padding),
              Center(
                child: ElevatedButton(
                  onPressed: applyLoan,
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
                    'Apply Now',
                    style: TextStyle(
                      color: ColorsField.backgroundLight,
                      fontSize: filterFontSize,
                    ),
                  ),
                ),
              ),
              SizedBox(height: padding * 2),
              // EMI Calculator
              Text(
                'EMI Calculator',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: ColorsField.blackColor,
                ),
              ),
              SizedBox(height: padding),
              TextField(
                controller: _emiAmountController,
                decoration: InputDecoration(
                  labelText: 'Loan Amount (₹)',
                  labelStyle: TextStyle(fontSize: descriptionFontSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                style: TextStyle(fontSize: descriptionFontSize),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => calculateEMI(),
              ),
              SizedBox(height: padding),
              TextField(
                controller: _emiTenureController,
                decoration: InputDecoration(
                  labelText: 'Tenure (Months)',
                  labelStyle: TextStyle(fontSize: descriptionFontSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                style: TextStyle(fontSize: descriptionFontSize),
                keyboardType: TextInputType.number,
                onChanged: (_) => calculateEMI(),
              ),
              SizedBox(height: padding),
              TextField(
                controller: _emiInterestController,
                decoration: InputDecoration(
                  labelText: 'Interest Rate (% p.a.)',
                  labelStyle: TextStyle(fontSize: descriptionFontSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                style: TextStyle(fontSize: descriptionFontSize),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => calculateEMI(),
              ),
              SizedBox(height: padding),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.025),
                ),
                child: Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Text(
                    'Monthly EMI: ₹${calculatedEMI.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: descriptionFontSize,
                      fontWeight: FontWeight.bold,
                      color: ColorsField.blackColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: padding * 2),
              // Repayment Schedule
              if (selectedLoan != null) ...[
                Text(
                  'Repayment Schedule (Loan ID: ${selectedLoan!['loanId']})',
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
                  itemCount: repaymentSchedule.length,
                  itemBuilder: (context, index) {
                    final entry = repaymentSchedule[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.025),
                      ),
                      child: ListTile(
                        title: Text(
                          'Month: ${entry['month']}',
                          style: TextStyle(fontSize: descriptionFontSize),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EMI: ₹${entry['emi'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: smallFontSize,
                                color: ColorsField.blackColor.withOpacity(0.7),
                              ),
                            ),
                            Text(
                              'Principal: ₹${entry['principal'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: smallFontSize,
                                color: ColorsField.blackColor.withOpacity(0.7),
                              ),
                            ),
                            Text(
                              'Interest: ₹${entry['interest'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: smallFontSize,
                                color: ColorsField.blackColor.withOpacity(0.7),
                              ),
                            ),
                            Text(
                              'Remaining Balance: ₹${entry['balance'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: smallFontSize,
                                color: ColorsField.blackColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}