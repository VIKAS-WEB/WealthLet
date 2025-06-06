import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class ReceiptScreen extends StatelessWidget {
  final Map<String, dynamic> transactionDetails;

  const ReceiptScreen({super.key, required this.transactionDetails});

  Future<void> _generateAndSavePdf(BuildContext context) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Payment Receipt',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Transaction Details', style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 10),
          ...transactionDetails.entries.map(
            (entry) => pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 4),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(entry.key, style: const pw.TextStyle(fontSize: 14)),
                  pw.Text(
                    entry.value.toString(),
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: entry.key == 'Total Amount'
                          ? pw.FontWeight.bold
                          : pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Text(
              'Thank you for your payment!',
              style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic), // Fixed here
            ),
          ),
        ],
      ),
    ),
  );

  try {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/receipt_${transactionDetails['Transaction ID']}.pdf');
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receipt downloaded and opened')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to generate receipt: $e')),
    );
  }


    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/receipt_${transactionDetails['Transaction ID']}.pdf');
      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receipt downloaded and opened')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate receipt: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transaction Receipt',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              const SizedBox(height: 12),
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
                transactionDetails['Date & Time'] ?? DateFormat('MMM d, yyyy | hh:mm a').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              // Transaction Details Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
                      ...transactionDetails.entries.map((entry) {
                        final isTotal = entry.key == 'Total Amount';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _getIconForKey(entry.key),
                                    size: 20,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      fontSize: isTotal ? 18 : 16,
                                      fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                entry.value.toString(),
                                style: TextStyle(
                                  fontSize: isTotal ? 18 : 16,
                                  fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                                  color: isTotal ? Colors.blueAccent : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Download Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _generateAndSavePdf(context),
                  icon: const Icon(Icons.download, size: 20),
                  label: const Text(
                    'Download Receipt',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
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

  // Helper method to assign icons based on key
  IconData _getIconForKey(String key) {
    switch (key) {
      case 'Transaction ID':
        return Icons.confirmation_number;
      case 'Amount':
      case 'Total Amount':
      // case 'Service Fee':
      //   return Icons.account_balance_wallet;
      case 'Source Account':
      case 'Destination Account':
        return Icons.account_balance;
      case 'Date & Time':
        return Icons.calendar_today;
      default:
        return Icons.info;
    }
  }
}

// Reusing the DashedDivider from your original code (if needed elsewhere)
class DashedDivider extends StatelessWidget {
  final double height;
  final Color color;

  const DashedDivider({
    super.key,
    this.height = 1,
    this.color = Colors.black26,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashWidth = 5.0;
        final dashCount = (constraints.constrainWidth() / (dashWidth * 2)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}