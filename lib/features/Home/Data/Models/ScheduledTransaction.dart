import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduledTransaction {
  final String id;
  final double amount;
  final String recipient;
  final DateTime date;
  final String type;
  final String status;
  final DateTime createdAt;

  ScheduledTransaction({
    required this.id,
    required this.amount,
    required this.recipient,
    required this.date,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  factory ScheduledTransaction.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ScheduledTransaction(
      id: doc.id,
      amount: data['amount']?.toDouble() ?? 0.0,
      recipient: data['recipient'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      type: data['type'] ?? '',
      status: data['status'] ?? 'Pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'amount': amount,
      'recipient': recipient,
      'date': Timestamp.fromDate(date),
      'type': type,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ScheduledTransaction copyWith({
    String? id,
    double? amount,
    String? recipient,
    DateTime? date,
    String? type,
    String? status,
    DateTime? createdAt,
  }) {
    return ScheduledTransaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      recipient: recipient ?? this.recipient,
      date: date ?? this.date,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}