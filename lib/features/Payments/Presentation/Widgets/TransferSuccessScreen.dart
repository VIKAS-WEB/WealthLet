import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:printing/printing.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';
import 'package:wealthlet/features/Payments/Presentation/Screens/InternalTransfer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class TransferSuccessScreen extends StatelessWidget {
  final String transactionId;
  final double amount;
  final String userId;
  final Map<String, dynamic> sourceAccount; // Added for dynamic data
  final Map<String, dynamic> destinationAccount; // Added for dynamic data

  const TransferSuccessScreen({
    Key? key,
    required this.transactionId,
    required this.amount,
    required this.userId,
    required this.sourceAccount,
    required this.destinationAccount,
  }) : super(key: key);

  Future<void> _saveTransactionDetails() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final transactionData = {
        'transactionId': transactionId,
        'amount': amount,
        'paymentMethod': 'Internal Transfer',
        'bankName': sourceAccount['bankName'] ?? 'Unknown Bank',
        'dateTime': DateTime.now().toIso8601String(),
        //'serviceFee': 5.00,
        'totalAmount': amount + 5.00,
        'sourceAccount': sourceAccount['name'] ?? 'Unknown',
        'sourceAccountNumber': sourceAccount['number'] ?? 'Unknown',
        'destinationAccount': destinationAccount['name'] ?? 'Unknown',
        'destinationAccountNumber': destinationAccount['number'] ?? 'Unknown',
      };

      await firestore
          .collection('users')
          .doc(userId)
          .collection('TransactionDetails')
          .doc(transactionId)
          .set(transactionData);
    } catch (e) {
      print('Error saving transaction details: $e');
    }
  }

  Future<void> _downloadReceipt(BuildContext context) async {
    final pdf = pw.Document();

    final dateTime = DateFormat('MMM d, yyyy | hh:mm a').format(DateTime.now());

    // Load logo
    final ByteData bytes = await rootBundle.load('assets/images/WealthLet.png');
    final Uint8List imageData = bytes.buffer.asUint8List();
    final pw.ImageProvider logo = pw.MemoryImage(imageData);

    // Load fonts from Google
    final RegularFont = await PdfGoogleFonts.notoSansRegular();
    final BoldFont = await PdfGoogleFonts.notoSansBold();

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(base: RegularFont, bold: BoldFont),
        build:
            (pw.Context context) => pw.Padding(
              padding: const pw.EdgeInsets.all(20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Transaction Receipt',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Transaction Details',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      0: const pw.FlexColumnWidth(2),
                      1: const pw.FlexColumnWidth(3),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Field',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                              'Details',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...[
                        {'Field': 'Transaction ID', 'Details': transactionId},
                        {
                          'Field': 'Amount',
                          'Details': '₹${amount.toStringAsFixed(2)}',
                        },
                        {
                          'Field': 'Source Account',
                          'Details':
                              '${sourceAccount['name']} (${sourceAccount['number']})',
                        },
                        {
                          'Field': 'Destination Account',
                          'Details':
                              '${destinationAccount['name']} (${destinationAccount['number']})',
                        },
                        {'Field': 'Date & Time', 'Details': dateTime},
                        {
                          'Field': 'Total Amount',
                          'Details': '₹${amount.toStringAsFixed(2)}',
                        },
                      ].map(
                        (entry) => pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(entry['Field']!),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                entry['Details']!,
                                style: pw.TextStyle(
                                  fontWeight:
                                      entry['Field'] == 'Total Amount'
                                          ? pw.FontWeight.bold
                                          : pw.FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(),
                  pw.SizedBox(height: 10),
                  pw.Center(
                    child: pw.Text(
                      'Thank you for your payment!',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                  ),
                  pw.Spacer(),
                  pw.Center(child: pw.Image(logo, width: 220)),
                ],
              ),
            ),
      ),
    );

    try {
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/receipt_$transactionId.pdf");
      await file.writeAsBytes(await pdf.save());

      // Open the file
      try {
        await OpenFile.open(file.path);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receipt downloaded and opened successfully!'),
          ),
        );
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Receipt downloaded but couldn\'t be opened. Find it at: ${file.path}',
            ),
          ),
        );
      }

      // Offer print option after download
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error generating receipt: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final dateTime = DateFormat('MMM d, yyyy | hh:mm a').format(DateTime.now());

    _saveTransactionDetails();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => InternalTransferScreen(),
              ),
            );
          },
          child: Icon(Icons.arrow_back, color: ColorsField.backgroundLight),
        ),
        title: Text(
          'Transfer Successful',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w500,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 23, 23, 23), ColorsField.buttonRed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Transaction Status Header
              Lottie.asset(
                'assets/lottie/Success.json',
                width: 180,
                height: 180,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 10),
              const Text(
                'Transaction Successful',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                dateTime,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              // Transaction Details Card
              SizedBox(
                width: screenWidth * 0.9,
                
                child: Card(
                  elevation: 5,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: const Color.fromARGB(153, 138, 138, 138)
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Transaction Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          'Transaction ID',
                          transactionId,
                          Icons.confirmation_number,
                        ),
                        _buildDetailRow(
                          'Amount',
                          '₹${amount.toStringAsFixed(2)}',
                          Icons.account_balance_wallet,
                        ),
                        _buildDetailRow(
                          'Source Account',
                          '${sourceAccount['name']} (${sourceAccount['number']})',
                          Icons.account_balance,
                        ),
                        _buildDetailRow(
                          'Destination Account',
                          '${destinationAccount['name']} (${destinationAccount['number']})',
                          Icons.account_balance,
                        ),
                        _buildDetailRow(
                          'Date & Time',
                          dateTime,
                          Icons.calendar_today,
                        ),
                        //_buildDetailRow('Service Fee', '₹5.00', Icons.account_balance_wallet),
                        _buildDetailRow(
                          'Total Amount',
                          '₹${(amount).toStringAsFixed(2)}',
                          Icons.account_balance_wallet,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _downloadReceipt(context),
                      icon: const Icon(Icons.download, size: 20),
                      label: const Text(
                        'Download Receipt',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsField.buttonRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/Home',
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: ColorsField.buttonRed),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Back to Home',
                        style: TextStyle(
                          color: ColorsField.buttonRed,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Footer Note
              Text(
                'Thank you for using our services!',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: isTotal ? 18 : 14,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? ColorsField.buttonRed : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
