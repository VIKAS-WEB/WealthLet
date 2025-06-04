import 'package:equatable/equatable.dart';
import 'package:wealthlet/features/Home/Data/Models/ScheduledTransaction.dart';

abstract class ScheduledTransactionState extends Equatable {
  const ScheduledTransactionState();

  @override
  List<Object> get props => [];
}

class ScheduledTransactionInitial extends ScheduledTransactionState {}

class ScheduledTransactionLoading extends ScheduledTransactionState {}

class ScheduledTransactionLoaded extends ScheduledTransactionState {
  final List<ScheduledTransaction> transactions;

  const ScheduledTransactionLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class ScheduledTransactionError extends ScheduledTransactionState {
  final String message;

  const ScheduledTransactionError(this.message);

  @override
  List<Object> get props => [message];
}