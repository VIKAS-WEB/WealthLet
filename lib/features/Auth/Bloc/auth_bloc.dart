import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      // Validate inputs
      if (event.email.trim().isEmpty || !event.email.contains('@')) {
        emit(const AuthFailure(errorMessage: 'Please enter a valid email address'));
        return;
      }
      if (event.password.trim().isEmpty || event.password.length < 6) {
        emit(const AuthFailure(errorMessage: 'Password must be at least 6 characters'));
        return;
      }

      // Attempt to sign in with Firebase
      await _auth.signInWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        default:
          errorMessage = 'Authentication failed: ${e.message}';
      }
      emit(AuthFailure(errorMessage: errorMessage));
    } catch (e) {
      emit(AuthFailure(errorMessage: 'An error occurred: $e'));
    }
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      // Validate inputs
      if (event.username.trim().isEmpty) {
        emit(const AuthFailure(errorMessage: 'Please enter a username'));
        return;
      }
      if (event.email.trim().isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(event.email)) {
        emit(const AuthFailure(errorMessage: 'Please enter a valid email'));
        return;
      }
      if (event.password.trim().isEmpty || event.password.length < 8) {
        emit(const AuthFailure(errorMessage: 'Password must be at least 8 characters'));
        return;
      }
      if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$').hasMatch(event.password)) {
        emit(const AuthFailure(errorMessage: 'Password must contain letters and numbers'));
        return;
      }

      // Create user with Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      // Update user profile with username
      await userCredential.user?.updateDisplayName(event.username.trim());

      // Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': event.username.trim(),
        'email': event.email.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'ProfilePic': '',
        'emailVerified': false,
        'fcmToken': await FirebaseMessaging.instance.getToken(),
      });

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email address is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak. Please use at least 8 characters.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      emit(AuthFailure(errorMessage: errorMessage));
    } catch (e) {
      emit(AuthFailure(errorMessage: 'An unexpected error occurred: $e'));
    }
  }
}