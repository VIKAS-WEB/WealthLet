import 'package:flutter/material.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';

class BankTransfer extends StatelessWidget {
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
          'Bank Transfer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
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
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for payee By Name Or Account Number',
                suffixIcon: Icon(Icons.arrow_drop_down),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          // Total Amount
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total available amount is',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  '\₹562554.29',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Expanded(
                   child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.star, color: Colors.white),
                      label: Text('All Payee', style: TextStyle(color: ColorsField.backgroundLight),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsField.buttonRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        
                      ),
                    ),
                                   ),
                 ),
                 SizedBox(width: 20,),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Add New Payee'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Divider(),
          // Recent Transactions Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Transaction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Recent Transactions List
          Expanded(
            child: ListView(
              children: [
                TransactionTile(
                  icon: Icons.account_circle,
                  name: 'MSBRARICI',
                  account: '180600000007',
                  amount: '\$5000',
                ),
                TransactionTile(
                  icon: Icons.account_circle,
                  name: 'SAHILBAJAJ',
                  account: '0206001000',
                  amount: '\$2460',
                ),
                TransactionTile(
                  icon: Icons.account_circle,
                  name: 'MANDEEPYOHRA',
                  account: '',
                  amount: '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final IconData icon;
  final String name;
  final String account;
  final String amount;

  TransactionTile({
    required this.icon,
    required this.name,
    required this.account,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(icon, color: Colors.white),
        backgroundColor: Colors.grey,
      ),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: account.isNotEmpty ? Text(account) : null,
      trailing: amount.isNotEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(amount, style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Repeat', style: TextStyle(color: Colors.blue)),
              ],
            )
          : Text('Repeat', style: TextStyle(color: Colors.blue)),
    );
  }
}