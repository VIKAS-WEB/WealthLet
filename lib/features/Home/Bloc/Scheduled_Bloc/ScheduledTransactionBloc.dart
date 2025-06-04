import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wealthlet/features/Home/Bloc/Scheduled_Bloc/ScheduledTransactionEvent.dart';
import 'package:wealthlet/features/Home/Bloc/Scheduled_Bloc/ScheduledTransactionState.dart';
import 'package:wealthlet/features/Home/Data/Models/ScheduledTransaction.dart' show ScheduledTransaction;

class ScheduledTransactionBloc
    extends Bloc<ScheduledTransactionEvent, ScheduledTransactionState> {
  ScheduledTransactionBloc() : super(ScheduledTransactionInitial()) {
    on<LoadScheduledTransactions>(_onLoadScheduledTransactions);
    on<AddScheduledTransaction>(_onAddScheduledTransaction);
    on<DeleteScheduledTransaction>(_onDeleteScheduledTransaction);
  }

  Future<void> _onLoadScheduledTransactions(
    LoadScheduledTransactions event,
    Emitter<ScheduledTransactionState> emit,
  ) async {
    emit(ScheduledTransactionLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      print('Current user UID: ${user?.uid}'); // Debug
      if (user == null) {
        emit(ScheduledTransactionError('User is not authenticated. Please sign in.'));
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('scheduled_transactions')
          .orderBy('date', descending: true)
          .get();

      final transactions = snapshot.docs
          .map((doc) => ScheduledTransaction.fromFirestore(doc))
          .toList();

      emit(ScheduledTransactionLoaded(transactions));
    } catch (e) {
      print('Error loading transactions: $e'); // Debug
      emit(ScheduledTransactionError('Failed to load transactions: $e'));
    }
  }

  Future<void> _onAddScheduledTransaction(
    AddScheduledTransaction event,
    Emitter<ScheduledTransactionState> emit,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      print('Current user UID: ${user?.uid}'); // Debug
      if (user == null) {
        emit(ScheduledTransactionError('User is not authenticated. Please sign in.'));
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('scheduled_transactions')
          .add(event.transaction.toFirestore());

      // Reload transactions after adding
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('scheduled_transactions')
          .orderBy('date', descending: true)
          .get();

      final transactions = snapshot.docs
          .map((doc) => ScheduledTransaction.fromFirestore(doc))
          .toList();

      emit(ScheduledTransactionLoaded(transactions));
    } catch (e) {
      print('Error adding transaction: $e'); // Debug
      emit(ScheduledTransactionError('Failed to schedule transaction: $e'));
    }
  }

  Future<void> _onDeleteScheduledTransaction(
    DeleteScheduledTransaction event,
    Emitter<ScheduledTransactionState> emit,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      print('Current user UID: ${user?.uid}'); // Debug
      if (user == null) {
        emit(ScheduledTransactionError('User is not authenticated. Please sign in.'));
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('scheduled_transactions')
          .doc(event.transactionId)
          .delete();

      // Reload transactions after deletion
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('scheduled_transactions')
          .orderBy('date', descending: true)
          .get();

      final transactions = snapshot.docs
          .map((doc) => ScheduledTransaction.fromFirestore(doc))
          .toList();

      emit(ScheduledTransactionLoaded(transactions));
    } catch (e) {
      print('Error deleting transaction: $e'); // Debug
      emit(ScheduledTransactionError('Failed to delete transaction: $e'));
    }
  }
}