import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddAccountScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Account')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Account Name (e.g., Visa Classic)'),
            ),
            TextField(
              controller: _numberController,
              decoration: InputDecoration(labelText: 'Account Number (e.g., 9182 **** **** 1177)'),
            ),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Account Type (e.g., Visa, MasterCard)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                final docRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('accounts')
                    .doc();

                await docRef.set({
                  'accountId': docRef.id,
                  'name': _nameController.text,
                  'number': _numberController.text,
                  'type': _typeController.text,
                  'balance': 0.0,
                });

                Navigator.pop(context);
              },
              child: Text('Add Account'),
            ),
          ],
        ),
      ),
    );
  }
}