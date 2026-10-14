import 'package:equatable/equatable.dart';

/// Transaction record representing a deposit, yield, or withdrawal in the ledger.
class TransactionItem extends Equatable {
  final String id;
  final String title;
  final String category;
  final double amount;
  final bool isCredit;
  final String status;
  final String dateLabel;
  final String iconKey;
  final DateTime createdAt;

  const TransactionItem({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.isCredit,
    required this.status,
    required this.dateLabel,
    required this.iconKey,
    required this.createdAt,
  });

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      isCredit: (map['is_credit'] is int)
          ? map['is_credit'] == 1
          : (map['is_credit'] as bool? ?? true),
      status: map['status']?.toString() ?? 'Completed',
      dateLabel: map['date_label']?.toString() ?? '',
      iconKey: map['icon_key']?.toString() ?? 'shield',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'is_credit': isCredit ? 1 : 0,
      'status': status,
      'date_label': dateLabel,
      'icon_key': iconKey,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        amount,
        isCredit,
        status,
        dateLabel,
        iconKey,
        createdAt,
      ];
}
