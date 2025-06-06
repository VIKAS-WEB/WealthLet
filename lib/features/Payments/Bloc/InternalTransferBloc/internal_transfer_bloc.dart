import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:typed_data';

import 'package:wealthlet/features/Payments/Bloc/InternalTransferBloc/internal_transfer_event.dart';
import 'package:wealthlet/features/Payments/Bloc/InternalTransferBloc/internal_transfer_state.dart';

class InternalTransferBloc extends Bloc<InternalTransferEvent, InternalTransferState> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  InternalTransferBloc(this.flutterLocalNotificationsPlugin) : super(InternalTransferInitial()) {
    on<FetchAccountsEvent>(_onFetchAccounts);
    on<ProcessTransferEvent>(_onProcessTransfer);
  }

  Future<void> _onFetchAccounts(FetchAccountsEvent event, Emitter<InternalTransferState> emit) async {
    emit(InternalTransferLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(InternalTransferError('User is not authenticated. Please sign in.'));
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('accounts')
          .get();

      if (snapshot.docs.length >= 2) {
        emit(InternalTransferLoaded(snapshot.docs[0].data(), snapshot.docs[1].data()));
      } else {
        emit(InternalTransferError('You need at least two accounts to make a transfer. Please add another account.'));
      }
    } catch (e) {
      emit(InternalTransferError('Failed to load accounts: $e'));
    }
  }

  Future<void> _onProcessTransfer(ProcessTransferEvent event, Emitter<InternalTransferState> emit) async {
    final currentState = state;
    if (currentState is InternalTransferLoaded) {
      final sourceAccount = currentState.sourceAccount;
      final destinationAccount = currentState.destinationAccount;
      final amount = event.amount;

      if (sourceAccount == null || destinationAccount == null) {
        emit(InternalTransferError('Account data is missing. Please try again.'));
        return;
      }

      final sourceBalance = (sourceAccount['balance'] is int
              ? (sourceAccount['balance'] as int).toDouble()
              : sourceAccount['balance'] as double?) ??
          0.0;
      if (sourceBalance < amount) {
        emit(InternalTransferError('Insufficient balance in source account.'));
        return;
      }

      final destBalance = (destinationAccount['balance'] is int
              ? (destinationAccount['balance'] as int).toDouble()
              : destinationAccount['balance'] as double?) ??
          0.0;

      emit(InternalTransferLoading());

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(InternalTransferError('User is not authenticated. Please sign in.'));
          return;
        }

        final batch = FirebaseFirestore.instance.batch();
        final transactionId = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('transactions')
            .doc()
            .id;

        final sourceRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('accounts')
            .doc(sourceAccount['accountId']);
        batch.update(sourceRef, {'balance': sourceBalance - amount});

        final destRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('accounts')
            .doc(destinationAccount['accountId']);
        batch.update(destRef, {'balance': destBalance + amount});

        final transactionRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('transactions')
            .doc(transactionId);
        batch.set(transactionRef, {
          'type': 'transfer',
          'sourceAccountId': sourceAccount['accountId'],
          'destinationAccountId': destinationAccount['accountId'],
          'amount': amount,
          'date': Timestamp.now(),
          'status': 'completed',
        });

        await batch.commit();

        await _showNotification(amount, transactionId);
        emit(InternalTransferSuccess(transactionId, amount));
      } catch (e) {
        emit(InternalTransferError('Failed to process transfer: $e'));
      }
    } else {
      emit(InternalTransferError('Invalid state for processing transfer.'));
    }
  }

  Future<void> _showNotification(double amount, String transactionId) async {
    final androidDetails = AndroidNotificationDetails(
      'transfer_channel',
      'Transfer Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      enableVibration: true,
      vibrationPattern: Int64List.fromList(const [0, 500, 200, 500]),
    );
    const iosDetails = DarwinNotificationDetails(
      sound: 'notification_sound.mp3',
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
    );
    final platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Transfer Successful',
        'Transferred \₹${amount.toStringAsFixed(2)} (Transaction ID: $transactionId)',
        platformDetails,
      );
    } catch (e) {
      print('Failed to show notification: $e');
    }
  }
}