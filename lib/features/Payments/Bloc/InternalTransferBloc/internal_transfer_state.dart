abstract class InternalTransferState {}

class InternalTransferInitial extends InternalTransferState {}

class InternalTransferLoading extends InternalTransferState {}

class InternalTransferLoaded extends InternalTransferState {
  final Map<String, dynamic>? sourceAccount;
  final Map<String, dynamic>? destinationAccount;
  InternalTransferLoaded(this.sourceAccount, this.destinationAccount);
}

class InternalTransferError extends InternalTransferState {
  final String message;
  InternalTransferError(this.message);
}

class InternalTransferSuccess extends InternalTransferState {
  final String transactionId;
  final double amount;
  InternalTransferSuccess(this.transactionId, this.amount);
}