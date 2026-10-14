class SavingsPlan {
  final String id;
  final String name;
  final String productId;
  final String productName;
  final double amount;
  final double targetAmount;
  final double monthlyContribution;
  final String frequency;
  final String duration;
  final DateTime createdAt;

  const SavingsPlan({
    required this.id,
    required this.name,
    required this.productId,
    required this.productName,
    required this.amount,
    required this.targetAmount,
    required this.monthlyContribution,
    required this.frequency,
    required this.duration,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'productId': productId,
        'productName': productName,
        'amount': amount,
        'targetAmount': targetAmount,
        'monthlyContribution': monthlyContribution,
        'frequency': frequency,
        'duration': duration,
        'createdAt': createdAt.toIso8601String(),
      };

  factory SavingsPlan.fromJson(Map<String, dynamic> json) {
    return SavingsPlan(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      productName: json['productName'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      targetAmount: (json['targetAmount'] as num?)?.toDouble() ?? 0.0,
      monthlyContribution:
          (json['monthlyContribution'] as num?)?.toDouble() ?? 0.0,
      frequency: json['frequency'] as String? ?? 'Monthly',
      duration: json['duration'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  SavingsPlan copyWith({
    String? id,
    String? name,
    String? productId,
    String? productName,
    double? amount,
    double? targetAmount,
    double? monthlyContribution,
    String? frequency,
    String? duration,
    DateTime? createdAt,
  }) {
    return SavingsPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      amount: amount ?? this.amount,
      targetAmount: targetAmount ?? this.targetAmount,
      monthlyContribution: monthlyContribution ?? this.monthlyContribution,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsPlan &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
