import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:wealthlet/utils/Colorfields.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _profilePicUrl;
  bool _isImageLoading = true; // Track image loading state
  final picker = ImagePicker();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  // Cloudinary details
  final String cloudName = 'dacwm4tte';
  final String uploadPreset = 'Wealthlet_Preset';

  @override
  void initState() {
    super.initState();
    _loadProfilePic();
  }

  Future<void> _loadProfilePic() async {
    if (userId == null) {
      setState(() {
        _isImageLoading = false;
      });
      return;
    }
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists && doc['ProfilePic'] != null) {
        setState(() {
          _profilePicUrl = doc['ProfilePic'];
        });
        // Start listening to image loading
        _listenToImageLoading();
      } else {
        setState(() {
          _isImageLoading = false;
        });
      }
    } catch (e) {
      print("❌ Error loading profile pic: $e");
      setState(() {
        _isImageLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile picture')),
      );
    }
  }

  void _listenToImageLoading() {
    if (_profilePicUrl == null) {
      setState(() {
        _isImageLoading = false;
      });
      return;
    }
    final imageProvider = NetworkImage(_profilePicUrl!);
    imageProvider
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener(
          (ImageInfo info, bool synchronousCall) {
            if (mounted) {
              setState(() {
                _isImageLoading = false;
              });
            }
          },
          onError: (exception, stackTrace) {
            if (mounted) {
              setState(() {
                _isImageLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to load profile image')),
              );
            }
          },
        ));
  }

  Future<void> _pickAndUploadImage() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user logged in')),
      );
      return;
    }

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
      return;
    }

    setState(() {
      _isImageLoading = true;
    });

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

        // Listen to the new image loading
        _listenToImageLoading();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture uploaded successfully')),
        );
      } else {
        setState(() {
          _isImageLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isImageLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
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
              alignment: Alignment.center,
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
                  onBackgroundImageError: _profilePicUrl != null
                      ? (exception, stackTrace) {
                          setState(() {
                            _isImageLoading = false;
                          });
                        }
                      : null,
                ),
                if (_isImageLoading && _profilePicUrl != null)
                  SpinKitPulse(
                    color: ColorsField.buttonRed,
                    size: 50.0,
                  ),
                  Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
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