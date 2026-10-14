import '../../data/models/financial_tip.dart';

sealed class TipsState {
  const TipsState();
}

class TipsInitial extends TipsState {
  const TipsInitial();
}

class TipsLoading extends TipsState {
  const TipsLoading();
}

class TipsLoaded extends TipsState {
  final List<FinancialTip> tips;
  const TipsLoaded(this.tips);
}

class TipsError extends TipsState {
  final String message;
  const TipsError(this.message);
}
