import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/savings_plan.dart';

abstract class SavingsLocalDataSource {
  Future<void> savePlans(List<SavingsPlan> plans);

  Future<List<SavingsPlan>> getPlans();

  Future<void> addPlan(SavingsPlan plan);
}

class SavingsLocalDataSourceImpl implements SavingsLocalDataSource {
  SavingsLocalDataSourceImpl({SharedPreferences? prefs}) : _prefs = prefs;

  final SharedPreferences? _prefs;

  static const String _keySavingsPlans = 'saved_savings_plans';

  Future<SharedPreferences> _getPrefs() async =>
      _prefs ?? await SharedPreferences.getInstance();

  @override
  Future<void> savePlans(List<SavingsPlan> plans) async {
    final prefs = await _getPrefs();
    final jsonList = plans.map((plan) => jsonEncode(plan.toJson())).toList();
    await prefs.setStringList(_keySavingsPlans, jsonList);
  }

  @override
  Future<List<SavingsPlan>> getPlans() async {
    final prefs = await _getPrefs();
    final list = prefs.getStringList(_keySavingsPlans);
    if (list == null || list.isEmpty) {
      return [];
    }
    return list.map((item) {
      final json = jsonDecode(item) as Map<String, dynamic>;
      return SavingsPlan.fromJson(json);
    }).toList();
  }

  @override
  Future<void> addPlan(SavingsPlan plan) async {
    final currentPlans = await getPlans();
    final updated = [plan, ...currentPlans.where((p) => p.id != plan.id)];
    await savePlans(updated);
  }
}
