abstract class InternalTransferEvent {}

class FetchAccountsEvent extends InternalTransferEvent {}

class ProcessTransferEvent extends InternalTransferEvent {
  final double amount;
  ProcessTransferEvent(this.amount);
}