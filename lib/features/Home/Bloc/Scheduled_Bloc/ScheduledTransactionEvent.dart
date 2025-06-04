import 'package:equatable/equatable.dart';
import 'package:wealthlet/features/Home/Data/Models/ScheduledTransaction.dart';

abstract class ScheduledTransactionEvent extends Equatable {
  const ScheduledTransactionEvent();

  @override
  List<Object> get props => [];
}

class LoadScheduledTransactions extends ScheduledTransactionEvent {}

class AddScheduledTransaction extends ScheduledTransactionEvent {
  final ScheduledTransaction transaction;

  const AddScheduledTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class DeleteScheduledTransaction extends ScheduledTransactionEvent {
  final String transactionId;

  const DeleteScheduledTransaction(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}