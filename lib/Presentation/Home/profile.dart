import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _profilePicUrl;
  final picker = ImagePicker();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  // 👇 Your Cloudinary details
  final String cloudName = 'dacwm4tte';
  final String uploadPreset = 'Wealthlet_Preset';

  @override
  void initState() {
    super.initState();
    _loadProfilePic();
  }

  Future<void> _loadProfilePic() async {
    if (userId == null) return;
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists && doc['ProfilePic'] != null) {
        setState(() {
          _profilePicUrl = doc['ProfilePic'];
        });
      }
    } catch (e) {
      print("❌ Error loading profile pic: $e");
    }
  }

  Future<void> _pickAndUploadImage() async {
    if (userId == null) {
      print("❌ No user logged in");
      return;
    }

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      print("ℹ️ No image selected");
      return;
    }

    try {
      String uploadUrl = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', pickedFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonData = json.decode(responseData);
        String imageUrl = jsonData['secure_url'];

        // Save URL to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set({'ProfilePic': imageUrl}, SetOptions(merge: true));

        setState(() {
          _profilePicUrl = imageUrl;
        });

        print("✅ Upload done: $imageUrl");
      } else {
        print("❌ Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error uploading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profilePicUrl != null
                      ? NetworkImage(_profilePicUrl!)
                      : null,
                  child: _profilePicUrl == null
                      ? Icon(Icons.person, size: 50, color: Colors.grey[600])
                      : null,
                  backgroundColor: Colors.grey[300],
                ),
                GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                    ),
                    child: Icon(Icons.edit, size: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text('Jitendra Rajput'),
                    ),
                    ListTile(
                      leading: Icon(Icons.email_outlined),
                      title: Text('jr@gmail.com'),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone_outlined),
                      title: Text('+91 99999 99999'),
                    ),
                    ListTile(
                      leading: Icon(Icons.home_outlined),
                      title: Text('Bhopal, India'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
