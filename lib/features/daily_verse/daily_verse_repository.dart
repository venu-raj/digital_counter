import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_counter/features/daily_verse/daily_verse_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final dailyVerseRepositoryProvider = Provider((ref) {
  return DailyVerseRepository(firestore: FirebaseFirestore.instance);
});

class DailyVerseRepository {
  final FirebaseFirestore firestore;

  DailyVerseRepository({
    required this.firestore,
  });

  Future<Either<String, DailyVerseModel>> uploadDailyVerseToFirebase({
    required String desc,
    required String docId,
  }) async {
    try {
      DailyVerseModel dailyVerseModel = DailyVerseModel(
        docId: docId,
        desc: desc,
        createdAt: DateTime.now(),
      );
      await firestore
          .collection("daily-verse")
          .doc(docId)
          .set(dailyVerseModel.toMap());

      final res = await firestore
          .collection("daily-verse")
          .where("createdAt",
              isLessThan: Timestamp.fromMicrosecondsSinceEpoch(86400000))
          .get()
          .then((value) => DailyVerseModel.fromMap(
              value.docs.first as Map<String, dynamic>));

      await firestore.collection("daily-verse").doc(res.docId).delete();

      return right(dailyVerseModel);
    } catch (e) {
      return left(e.toString());
    }
  }

  void delectVerse({
    required String desc,
    required String docId,
  }) async {
    // await firestore.collection("daily-verse").doc(docId).delete();
    final res = await firestore
        .collection("daily-verse")
        .where("createdAt",
            isLessThan: Timestamp.fromMicrosecondsSinceEpoch(86400000))
        .get()
        .then((value) =>
            DailyVerseModel.fromMap(value.docs.first as Map<String, dynamic>));

    await firestore.collection("daily-verse").doc(res.docId).delete();
  }

  Stream<List<DailyVerseModel?>> getDocuments() {
    return firestore.collection("daily-verse").snapshots().map(
          (event) => event.docs
              .map(
                (e) => DailyVerseModel.fromMap(
                  e.data(),
                ),
              )
              .toList(),
        );
  }
}
