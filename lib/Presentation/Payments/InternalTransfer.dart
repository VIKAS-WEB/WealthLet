import 'package:flutter/material.dart';
import 'package:wealthlet/utils/Colorfields.dart';


class InternalTransferScreen extends StatelessWidget {
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
          'Transfer between own accounts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SOURCE ACCOUNT',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Image.asset(
                  'assets/images/Visa.png',
                  width: 40,
                ),
                title: Text(
                  'Visa Classic',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  '9182 **** **** 1177',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                // trailing: Text(
                //   '\₹ 1179',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                // ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'DESTINATION ACCOUNT',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Image.asset(
                  'assets/images/MasterCard.png',
                  width: 40,
                ),
                title: Text(
                  'MasterCard',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  '8473 **** **** 9932',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                // trailing: Text(
                //   '\₹ 176.12',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                // ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'AMOUNT',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                prefixText: '\$ ',
                prefixStyle: TextStyle(fontSize: 18, color: Colors.black),
                hintText: '0',
                hintStyle: TextStyle(fontSize: 18, color: Colors.black),
                border: UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsField.buttonRed,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'NEXT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}