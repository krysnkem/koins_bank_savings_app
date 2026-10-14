import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';

class UiPlan {
  final String id;
  final String name;
  final String productId;
  final String productName;
  final double amount;
  final double targetAmount;
  final double monthlyContribution;
  final String frequency;
  final String duration;

  const UiPlan({
    required this.id,
    required this.name,
    required this.productId,
    required this.productName,
    required this.amount,
    required this.targetAmount,
    required this.monthlyContribution,
    required this.frequency,
    required this.duration,
  });
}

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

class UiSession {
  final bool loggedIn;
  final List<UiPlan> plans;

  const UiSession({required this.loggedIn, required this.plans});

  static const seed = [
    UiPlan(
      id: 'seed-1',
      name: 'Emergency Fund',
      productId: '1',
      productName: 'Target Savings',
      amount: 120000,
      targetAmount: 500000,
      monthlyContribution: 20000,
      frequency: 'Monthly',
      duration: '12 Months',
    ),
    UiPlan(
      id: 'seed-2',
      name: 'House Savings Plan',
      productId: '2',
      productName: 'Fixed Deposit',
      amount: 250000,
      targetAmount: 2000000,
      monthlyContribution: 50000,
      frequency: 'Monthly',
      duration: '6 Months',
    ),
    UiPlan(
      id: 'seed-3',
      name: 'Education Plan',
      productId: '3',
      productName: 'Education Savings',
      amount: 180000,
      targetAmount: 800000,
      monthlyContribution: 15000,
      frequency: 'Monthly',
      duration: 'Flexible',
    ),
  ];

  UiSession copyWith({bool? loggedIn, List<UiPlan>? plans}) {
    return UiSession(
      loggedIn: loggedIn ?? this.loggedIn,
      plans: plans ?? this.plans,
    );
  }
}

class UiSessionNotifier extends StateNotifier<UiSession> {
  UiSessionNotifier() : super(const UiSession(loggedIn: false, plans: UiSession.seed));

  /// EXPECTATION: AuthRepository.login → MockBackendService.login, then saveSession.
  Future<String?> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (email.trim().toLowerCase() != AppConstants.mockEmail ||
        password != AppConstants.mockPassword) {
      return 'Invalid email or password';
    }
    state = state.copyWith(loggedIn: true);
    return null;
  }

  /// EXPECTATION: AuthRepository.logout → AuthLocalDataSource.clearSession.
  void logout() => state = state.copyWith(loggedIn: false);

  /// EXPECTATION: SavingsRepository.createPlan → MockBackendService.createSavingsPlan.
  void addPlan(UiPlan plan) {
    state = state.copyWith(plans: [plan, ...state.plans]);
  }
}

final uiSessionProvider = StateNotifierProvider<UiSessionNotifier, UiSession>(
  (ref) => UiSessionNotifier(),
);

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

const kDashboardTotal = 850000.0;

const kDurations = ['3 Months', '6 Months', '12 Months', '24 Months', 'Flexible'];

UiProduct? productById(String id) {
  for (final product in kProducts) {
    if (product.id == id) return product;
  }
  return null;
}
