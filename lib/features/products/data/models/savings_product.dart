class SavingsProduct {
  final String id;
  final String name;
  final double interestRate;
  final String duration;
  final String shortDescription;
  final double minimumDeposit;

  const SavingsProduct({
    required this.id,
    required this.name,
    required this.interestRate,
    required this.duration,
    required this.shortDescription,
    required this.minimumDeposit,
  });
}
