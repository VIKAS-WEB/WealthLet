import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:wealthlet/features/Profile/Bloc/profile_event.dart';
import 'package:wealthlet/features/Profile/Bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final String cloudName = 'dacwm4tte';
  final String uploadPreset = 'Wealthlet_Preset';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfilePicture>(_onLoadProfilePicture);
    on<UploadProfilePicture>(_onUploadProfilePicture);
    on<ProfilePictureLoadFailed>(_onProfilePictureLoadFailed);
    on<UpdatePhoneNumber>(_onUpdatePhoneNumber);
    on<UpdateEmail>(_onUpdateEmail);
    on<UpdateAddress>(_onUpdateAddress);
  }

  Future<void> _onLoadProfilePicture(
      LoadProfilePicture event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      emit(const ProfileError(errorMessage: 'No user logged in'));
      return;
    }

    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        emit(ProfilePictureLoaded(
          profilePicUrl: data?['ProfilePic'] as String?,
          isImageLoading: data?['ProfilePic'] != null,
          name: data?['username'] as String? ?? 'Unknown',
          email: data?['email'] as String? ?? 'No email',
          phoneNumber: data?['phoneNumber'] as String?,
          address: data?['address'] as String?,
        ));
      } else {
        emit(const ProfilePictureLoaded(
          isImageLoading: false,
          name: 'Unknown',
          email: 'No email',
        ));
      }
    } catch (e) {
      emit(ProfileError(errorMessage: 'Failed to load profile data: $e'));
    }
  }

  Future<void> _onUploadProfilePicture(
      UploadProfilePicture event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      emit(const ProfileError(errorMessage: 'No user logged in'));
      return;
    }

    try {
      String uploadUrl = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', event.imagePath));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonData = json.decode(responseData);
        String imageUrl = jsonData['secure_url'];

        await _firestore
            .collection('users')
            .doc(userId)
            .set({'ProfilePic': imageUrl}, SetOptions(merge: true));

        DocumentSnapshot doc =
            await _firestore.collection('users').doc(userId).get();
        final data = doc.data() as Map<String, dynamic>?;
        emit(ProfilePictureLoaded(
          profilePicUrl: imageUrl,
          isImageLoading: true,
          name: data?['username'] as String? ?? 'Unknown',
          email: data?['email'] as String? ?? 'No email',
          phoneNumber: data?['phoneNumber'] as String?,
          address: data?['address'] as String?,
        ));
      } else {
        emit(const ProfilePictureLoaded(
          isImageLoading: false,
          name: 'Unknown',
          email: 'No email',
        ));
        emit(ProfileError(errorMessage: 'Upload failed: ${response.statusCode}'));
      }
    } catch (e) {
      emit(const ProfilePictureLoaded(
        isImageLoading: false,
        name: 'Unknown',
        email: 'No email',
      ));
      emit(ProfileError(errorMessage: 'Error uploading image: $e'));
    }
  }

  void _onProfilePictureLoadFailed(
      ProfilePictureLoadFailed event, Emitter<ProfileState> emit) {
    if (state is ProfilePictureLoaded) {
      final currentState = state as ProfilePictureLoaded;
      emit(ProfilePictureLoaded(
        profilePicUrl: currentState.profilePicUrl,
        isImageLoading: false,
        name: currentState.name,
        email: currentState.email,
        phoneNumber: currentState.phoneNumber,
        address: currentState.address,
      ));
    } else {
      emit(const ProfilePictureLoaded(
        isImageLoading: false,
        name: 'Unknown',
        email: 'No email',
      ));
    }
  }

  Future<void> _onUpdatePhoneNumber(
      UpdatePhoneNumber event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      emit(const ProfileError(errorMessage: 'No user logged in'));
      return;
    }

    try {
      await _firestore.collection('users').doc(userId).set({
        'phoneNumber': event.phoneNumber,
      }, SetOptions(merge: true));

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      final data = doc.data() as Map<String, dynamic>?;
      emit(ProfilePictureLoaded(
        profilePicUrl: data?['ProfilePic'] as String?,
        isImageLoading: data?['ProfilePic'] != null,
        name: data?['username'] as String? ?? 'Unknown',
        email: data?['email'] as String? ?? 'No email',
        phoneNumber: event.phoneNumber,
        address: data?['address'] as String?,
      ));
    } catch (e) {
      emit(ProfileError(errorMessage: 'Failed to update phone number: $e'));
    }
  }

  Future<void> _onUpdateEmail(
      UpdateEmail event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      emit(const ProfileError(errorMessage: 'No user logged in'));
      return;
    }

    try {
      await _firestore.collection('users').doc(userId).set({
        'email': event.email,
      }, SetOptions(merge: true));

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      final data = doc.data() as Map<String, dynamic>?;
      emit(ProfilePictureLoaded(
        profilePicUrl: data?['ProfilePic'] as String?,
        isImageLoading: data?['ProfilePic'] != null,
        name: data?['username'] as String? ?? 'Unknown',
        email: event.email,
        phoneNumber: data?['phoneNumber'] as String?,
        address: data?['address'] as String?,
      ));
    } catch (e) {
      emit(ProfileError(errorMessage: 'Failed to update email: $e'));
    }
  }

  Future<void> _onUpdateAddress(
      UpdateAddress event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      emit(const ProfileError(errorMessage: 'No user logged in'));
      return;
    }

    try {
      await _firestore.collection('users').doc(userId).set({
        'address': event.address,
      }, SetOptions(merge: true));

      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      final data = doc.data() as Map<String, dynamic>?;
      emit(ProfilePictureLoaded(
        profilePicUrl: data?['ProfilePic'] as String?,
        isImageLoading: data?['ProfilePic'] != null,
        name: data?['username'] as String? ?? 'Unknown',
        email: data?['email'] as String? ?? 'No email',
        phoneNumber: data?['phoneNumber'] as String?,
        address: event.address,
      ));
    } catch (e) {
      emit(ProfileError(errorMessage: 'Failed to update address: $e'));
    }
  }
}