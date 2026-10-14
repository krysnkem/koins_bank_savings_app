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
}
