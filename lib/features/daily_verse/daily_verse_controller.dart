import 'package:digital_counter/features/daily_verse/daily_verse_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:digital_counter/features/daily_verse/daily_verse_repository.dart';

final dailyVerseProvider =
    StateNotifierProvider<DailyVerseProvider, bool>((ref) {
  return DailyVerseProvider(ref.watch(dailyVerseRepositoryProvider));
});

final getDocumentsProvider = StreamProvider((ref) {
  final controller = ref.watch(dailyVerseProvider.notifier);
  return controller.getDocuments();
});

class DailyVerseProvider extends StateNotifier<bool> {
  final DailyVerseRepository dailyVerseRepository;
  DailyVerseProvider(
    this.dailyVerseRepository,
  ) : super(false);

  void uploadDailyVerseToFirebase({
    required String desc,
    required String docId,
  }) async {
    final res = await dailyVerseRepository.uploadDailyVerseToFirebase(
      desc: desc,
      docId: docId,
    );

    res.fold((l) => print(l.toString()), (r) => null);
  }

  // void delectVerse({
  //   required String desc,
  //   required String docId,
  // }) async {
  //   return dailyVerseRepository.delectVerse(
  //     desc: desc,
  //     docId: docId,
  //   );
  // }

  Stream<List<DailyVerseModel?>> getDocuments() {
    return dailyVerseRepository.getDocuments();
  }
}
