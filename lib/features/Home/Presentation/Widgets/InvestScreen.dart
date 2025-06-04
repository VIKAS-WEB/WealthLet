import 'package:flutter/material.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For date formatting

class InvestScreen extends StatefulWidget {
  @override
  _InvestScreenState createState() => _InvestScreenState();
}

class _InvestScreenState extends State<InvestScreen> {
  // Sample investment options
  final List<Map<String, dynamic>> investmentOptions = [
    {
      'type': 'Mutual Funds',
      'name': 'SBI Bluechip Fund',
      'return': '12.5% p.a.',
    },
    {
      'type': 'Fixed Deposit',
      'name': 'HDFC FD',
      'return': '6.5% p.a.',
    },
    {
      'type': 'Stocks',
      'name': 'Reliance Industries',
      'return': '15% p.a.',
    },
  ];

  // Portfolio summary (demo data)
  double totalInvested = 150000;
  double totalReturns = 22500; // 15% returns for demo

  // Form controllers for investing more
  final _amountController = TextEditingController();
  String selectedScheme = 'SBI Bluechip Fund';
  List<String> schemes = ['SBI Bluechip Fund', 'HDFC FD', 'Reliance Industries'];

  // Map schemes to stock symbols (using .BSE suffix)
  final Map<String, String> schemeToSymbol = {
    'SBI Bluechip Fund': 'SBIN.BSE', // Proxy for SBI Bluechip Fund (SBI stock)
    'HDFC FD': 'HDFCBANK.BSE', // Proxy for HDFC FD (HDFC Bank stock)
    'Reliance Industries': 'RELIANCE.BSE',
  };

  // Dynamic performance data for line chart (initially empty)
  List<Map<String, dynamic>> performanceData = [];

  // Flag to check if data is loading
  bool isLoading = true;

  // For high/low annotations
  double? maxPrice;
  double? minPrice;
  int? maxPriceIndex;
  int? minPriceIndex;

  @override
  void initState() {
    super.initState();
    fetchStockData(); // Fetch initial stock data on screen load
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // Function to fetch stock data from Alpha Vantage API based on selected scheme
  Future<void> fetchStockData() async {
    setState(() {
      isLoading = true; // Show loading indicator while fetching data
      performanceData = []; // Clear previous data
    });

    const String apiKey = 'YOUR_ALPHA_VANTAGE_API_KEY'; // Replace with your Alpha Vantage API key
    final String symbol = schemeToSymbol[selectedScheme] ?? 'AAPL'; // Get symbol for selected scheme
    final String url =
        'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&outputsize=compact&apikey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      print('API Response Status Code: ${response.statusCode}'); // Debug
      print('API Response Body: ${response.body}'); // Debug
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Parsed Data: $data'); // Debug

        // Check if the API returned an error or empty response
        if (data.isEmpty) {
          throw Exception('Empty response from API');
        }

        if (data.containsKey('Error Message')) {
          throw Exception('API Error: ${data['Error Message']}');
        }

        if (data.containsKey('Note')) {
          throw Exception('API Note: ${data['Note']}'); // Rate limit exceeded
        }

        // Check if 'Time Series (Daily)' exists
        if (!data.containsKey('Time Series (Daily)')) {
          throw Exception('Time Series (Daily) data not found in response');
        }

        // Extract the daily data
        Map<String, dynamic> dailyData = data['Time Series (Daily)'];
        List<Map<String, dynamic>> tempData = [];

        // Get the last 6 trading days
        int count = 0;
        double max = double.negativeInfinity;
        double min = double.infinity;
        int maxIndex = 0;
        int minIndex = 0;

        for (var entry in dailyData.entries) {
          if (count >= 6) break;
          double closePrice = double.parse(entry.value['4. close']);
          tempData.add({
            'date': entry.key, // Full date for formatting later
            'price': closePrice, // Actual price instead of normalized return
          });

          // Track max and min for annotations
          if (closePrice > max) {
            max = closePrice;
            maxIndex = count;
          }
          if (closePrice < min) {
            min = closePrice;
            minIndex = count;
          }
          count++;
        }

        setState(() {
          performanceData = tempData;
          maxPrice = max;
          minPrice = min;
          maxPriceIndex = maxIndex;
          minPriceIndex = minIndex;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load stock data: Status Code ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e'); // Debug
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching stock data: $e')),
      );
    }
  }

  // Function to invest more
  void investMore() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    setState(() {
      totalInvested += amount;
      totalReturns = totalInvested * 0.15; // 15% returns for demo
      _amountController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Investment added successfully!')),
    );
  }

  // Function to redeem
  void redeem() {
    if (totalInvested == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No investments to redeem')),
      );
      return;
    }
    setState(() {
      totalInvested = 0;
      totalReturns = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Redeemed successfully!')),
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

    // Calculate min and max Y values for the chart
    double minY = performanceData.isNotEmpty
        ? performanceData.map((e) => e['price'] as double).reduce((a, b) => a < b ? a : b) * 0.95
        : 0;
    double maxY = performanceData.isNotEmpty
        ? performanceData.map((e) => e['price'] as double).reduce((a, b) => a > b ? a : b) * 1.05
        : 100;

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
          'Invest',
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
      body: RefreshIndicator(
        onRefresh: fetchStockData,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Portfolio Summary
                Text(
                  'Portfolio Summary',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Invested',
                                  style: TextStyle(
                                    fontSize: descriptionFontSize,
                                    color: ColorsField.blackColor.withOpacity(0.7),
                                  ),
                                ),
                                Text(
                                  '₹${totalInvested.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsField.blackColor,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Returns',
                                  style: TextStyle(
                                    fontSize: descriptionFontSize,
                                    color: ColorsField.blackColor.withOpacity(0.7),
                                  ),
                                ),
                                Text(
                                  '₹${totalReturns.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: padding),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: redeem,
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
                                fontSize: smallFontSize,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: padding * 2),
                // Performance Chart
                Text(
                  'Performance ($selectedScheme)',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: ColorsField.blackColor,
                  ),
                ),
                SizedBox(height: padding),
                Container(
                  height: screenHeight * 0.3,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : performanceData.isEmpty
                          ? Center(child: Text('No data available'))
                          : LineChart(
                              LineChartData(
                                lineTouchData: LineTouchData(
                                  enabled: true,
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                      return touchedSpots.map((spot) {
                                        final date = performanceData[spot.x.toInt()]['date'] as String;
                                        final price = spot.y;
                                        return LineTooltipItem(
                                          '${DateFormat('dd MMM').format(DateTime.parse(date))}\n₹${price.toStringAsFixed(2)}',
                                          TextStyle(
                                            color: Colors.white,
                                            fontSize: smallFontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: true,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Colors.grey.withOpacity(0.2),
                                      strokeWidth: 1,
                                    );
                                  },
                                  getDrawingVerticalLine: (value) {
                                    return FlLine(
                                      color: Colors.grey.withOpacity(0.2),
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 2, // Show every second label to reduce overlap
                                      getTitlesWidget: (double value, TitleMeta meta) {
                                        // Ensure the index is within bounds
                                        if (value.toInt() >= performanceData.length) {
                                          return const Text('');
                                        }
                                        final date = performanceData[value.toInt()]['date'] as String;
                                        final formattedDate = DateFormat('dd MMM').format(DateTime.parse(date));
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Transform.rotate(
                                            angle: -45 * 3.14159 / 180, // Rotate labels by -45 degrees
                                            child: Text(
                                              formattedDate,
                                              style: TextStyle(
                                                fontSize: smallFontSize * 0.9, // Slightly smaller font size
                                                color: ColorsField.blackColor,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      },
                                      reservedSize: 40, // Increase reserved space for rotated labels
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (double value, TitleMeta meta) {
                                        return Text(
                                          '₹${value.toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontSize: smallFontSize,
                                            color: ColorsField.blackColor,
                                          ),
                                        );
                                      },
                                      reservedSize: 40, // Space for Y-axis labels
                                    ),
                                  ),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withOpacity(0.5))),
                                minX: 0,
                                maxX: (performanceData.length - 1).toDouble(),
                                minY: minY,
                                maxY: maxY,
                                extraLinesData: ExtraLinesData(
                                  extraLinesOnTop: false,
                                  horizontalLines: [
                                    if (maxPrice != null && maxPriceIndex != null)
                                      HorizontalLine(
                                        y: maxPrice!,
                                        color: Colors.green,
                                        strokeWidth: 1,
                                        dashArray: [5, 5],
                                        label: HorizontalLineLabel(
                                          show: true,
                                          alignment: Alignment.topRight,
                                          padding: EdgeInsets.only(right: 5, bottom: 5),
                                          style: TextStyle(
                                            fontSize: smallFontSize,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          labelResolver: (line) => 'High: ₹${line.y.toStringAsFixed(2)}',
                                        ),
                                      ),
                                    if (minPrice != null && minPriceIndex != null)
                                      HorizontalLine(
                                        y: minPrice!,
                                        color: Colors.red,
                                        strokeWidth: 1,
                                        dashArray: [5, 5],
                                        label: HorizontalLineLabel(
                                          show: true,
                                          alignment: Alignment.bottomRight,
                                          padding: EdgeInsets.only(right: 5, top: 5),
                                          style: TextStyle(
                                            fontSize: smallFontSize,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          labelResolver: (line) => 'Low: ₹${line.y.toStringAsFixed(2)}',
                                        ),
                                      ),
                                  ],
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: performanceData.asMap().entries.map((entry) {
                                      int index = entry.key;
                                      double price = entry.value['price'] as double;
                                      return FlSpot(index.toDouble(), price);
                                    }).toList(),
                                    isCurved: true,
                                    color: ColorsField.buttonRed,
                                    barWidth: 3,
                                    dotData: FlDotData(show: true),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: ColorsField.buttonRed.withOpacity(0.2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ),
                SizedBox(height: padding * 2),
                // Invest More Section
                Text(
                  'Invest More',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: ColorsField.blackColor,
                  ),
                ),
                SizedBox(height: padding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Scheme',
                      style: TextStyle(
                        fontSize: descriptionFontSize,
                        color: ColorsField.blackColor,
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedScheme,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedScheme = newValue!;
                          fetchStockData(); // Fetch new data when scheme changes
                        });
                      },
                      items: schemes.map<DropdownMenuItem<String>>((String scheme) {
                        return DropdownMenuItem<String>(
                          value: scheme,
                          child: Text(
                            scheme,
                            style: TextStyle(fontSize: smallFontSize),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: padding),
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
                Center(
                  child: ElevatedButton(
                    onPressed: investMore,
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
                      'Invest Now',
                      style: TextStyle(
                        color: ColorsField.backgroundLight,
                        fontSize: filterFontSize,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: padding * 2),
                // Available Investment Options
                Text(
                  'Available Investment Options',
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
                  itemCount: investmentOptions.length,
                  itemBuilder: (context, index) {
                    final option = investmentOptions[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.025),
                      ),
                      child: ListTile(
                        title: Text(
                          option['name'] ?? 'Unknown',
                          style: TextStyle(
                            fontSize: descriptionFontSize,
                            color: ColorsField.blackColor,
                          ),
                        ),
                        subtitle: Text(
                          '${option['type'] ?? 'Unknown'} - ${option['return'] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: smallFontSize,
                            color: ColorsField.blackColor.withOpacity(0.7),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: smallFontSize,
                          color: ColorsField.blackColor,
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selected ${option['name']}')),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}