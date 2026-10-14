import 'dart:async';
import 'package:koins_savings_app/core/constants/latency_constants.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  LatencyConstants.disableForTesting();
  await testMain();
}
