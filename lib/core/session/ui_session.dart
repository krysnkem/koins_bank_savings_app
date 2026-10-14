class UiProduct {
  final String id;
  final String name;
  final double interestRate;
  final String duration;
  final String shortDescription;
  final double minimumDeposit;
  final IconName icon;

  const UiProduct({
    required this.id,
    required this.name,
    required this.interestRate,
    required this.duration,
    required this.shortDescription,
    required this.minimumDeposit,
    required this.icon,
  });
}

enum IconName { flag, lock, school, flight }

const kProducts = <UiProduct>[
  UiProduct(
    id: '1',
    name: 'Target Savings',
    interestRate: 12,
    duration: '12 Months',
    shortDescription: 'Save towards a specific goal with competitive returns.',
    minimumDeposit: 5000,
    icon: IconName.flag,
  ),
  UiProduct(
    id: '2',
    name: 'Fixed Deposit',
    interestRate: 18,
    duration: '6 Months',
    shortDescription: 'Lock funds for a fixed period and earn higher interest.',
    minimumDeposit: 5000,
    icon: IconName.lock,
  ),
  UiProduct(
    id: '3',
    name: 'Education Savings',
    interestRate: 10,
    duration: 'Flexible',
    shortDescription: 'Flexible savings plan designed for education goals.',
    minimumDeposit: 5000,
    icon: IconName.school,
  ),
  UiProduct(
    id: '4',
    name: 'Vacation Savings',
    interestRate: 8,
    duration: 'Flexible',
    shortDescription: 'Build your travel fund at your own pace.',
    minimumDeposit: 5000,
    icon: IconName.flight,
  ),
];

const kDurations = ['3 Months', '6 Months', '12 Months', '24 Months', 'Flexible'];

UiProduct? productById(String id) {
  for (final product in kProducts) {
    if (product.id == id) return product;
  }
  return null;
}
