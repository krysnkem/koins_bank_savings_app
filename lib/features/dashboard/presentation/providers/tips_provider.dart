import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/repositories/tips_repository.dart';
import 'tips_state.dart';

export 'tips_state.dart';

final tipsNotifierProvider =
    NotifierProvider.autoDispose<TipsNotifier, TipsState>(TipsNotifier.new);

class TipsNotifier extends AutoDisposeNotifier<TipsState> {
  late final TipsRepository _tipsRepository;

  @override
  TipsState build() {
    _tipsRepository = ref.watch(tipsRepositoryProvider);
    return const TipsInitial();
  }

  Future<void> load() async {
    state = const TipsLoading();
    try {
      final tips = await _tipsRepository.getTips();
      state = TipsLoaded(tips);
    } catch (e) {
      if (e is AppException) {
        state = TipsError(e.message);
      } else {
        state = TipsError(
          e.toString().replaceFirst(RegExp(r'^(App)?Exception:\s*'), ''),
        );
      }
    }
  }
}
