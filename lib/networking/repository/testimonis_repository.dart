import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_counter/models/comment_model.dart';
import 'package:digital_counter/utils/enums/testimoni_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:digital_counter/models/testimonis_model.dart';
import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:digital_counter/networking/repository/storage_method.dart';
import 'package:uuid/uuid.dart';

final testimonisRepositoryProvider = Provider<TestimonisRepository>((ref) {
  return TestimonisRepository(
    firestore: FirebaseFirestore.instance,
    storageMethods: ref.watch(storageMethodsProvider),
  );
});

class TestimonisRepository {
  final FirebaseFirestore firestore;
  final StorageMethods storageMethods;

  TestimonisRepository({
    required this.firestore,
    required this.storageMethods,
  });
  Future<Either<String, TestimonisModel>> shareImageTweet({
    required XFile? images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
    required WidgetRef ref,
  }) async {
    try {
      final hashtags = _getHashtagsFromText(text);
      String link = _getLinkFromText(text);
      final user = ref.read(userProvider)!;
      final imageLinks =
          await storageMethods.uploadImageToStorage("testimonis", images, true);
      final uuid = const Uuid().v1();

      TestimonisModel testimonisModel = TestimonisModel(
        text: text,
        hashtags: hashtags,
        link: link,
        imageLinks: imageLinks,
        uid: user.uid,
        userName: user.name,
        profilePic: user.profilePic ??
            "https://t3.ftcdn.net/jpg/03/64/62/36/360_F_364623623_ERzQYfO4HHHyawYkJ16tREsizLyvcaeg.jpg",
        testimoniType: TestimoniType.image,
        createdAt: DateTime.now(),
        likes: [],
        commentIds: [],
        id: uuid,
        shareCount: 0,
      );

      await firestore
          .collection("testimonis")
          .doc(uuid)
          .set(testimonisModel.toMap());

      return right(testimonisModel);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, TestimonisModel>> shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
    required WidgetRef ref,
  }) async {
    try {
      final hashtags = _getHashtagsFromText(text);
      String link = _getLinkFromText(text);
      final user = ref.read(userProvider)!;
      final uuid = const Uuid().v1();

      TestimonisModel testimonisModel = TestimonisModel(
        text: text,
        hashtags: hashtags,
        link: link,
        imageLinks: "",
        uid: user.uid,
        userName: user.name,
        profilePic: user.profilePic ??
            "https://t3.ftcdn.net/jpg/03/64/62/36/360_F_364623623_ERzQYfO4HHHyawYkJ16tREsizLyvcaeg.jpg",
        testimoniType: TestimoniType.text,
        createdAt: DateTime.now(),
        likes: [],
        commentIds: [],
        id: uuid,
        shareCount: 0,
      );

      await firestore
          .collection("testimonis")
          .doc(uuid)
          .set(testimonisModel.toMap());

      return right(testimonisModel);
    } catch (e) {
      return left(e.toString());
    }
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  Stream<List<TestimonisModel>> getAllTestimonisModelFromFirebase() {
    try {
      return firestore
          .collection("testimonis")
          .orderBy("createdAt", descending: true)
          .snapshots()
          .map(
            (event) => event.docs
                .map(
                  (e) => TestimonisModel.fromMap(e.data()),
                )
                .toList(),
          );
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> likeThePost({
    required String testimonisId,
    required List likes,
    required String uid,
  }) async {
    if (likes.contains(uid)) {
      await firestore.collection('testimonis').doc(testimonisId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await firestore.collection('testimonis').doc(testimonisId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  // Future<void> commentThePost({
  //   required String postId,
  //   required List commentIds,
  //   required String message,
  // }) async {
  //   try {
  //     await firestore.collection('posts').doc(postId).update({
  //       'commentIds': FieldValue.arrayUnion([message])
  //     });
  //   } catch (e) {}
  // }

  Future<Either<String, CommentModel>> postComment({
    required String postId,
    required String text,
    required WidgetRef ref,
  }) async {
    try {
      final commentDocid = const Uuid().v1();
      final user = ref.watch(userProvider)!;

      CommentModel commentModel = CommentModel(
        userName: user.name,
        userUid: user.uid,
        text: text,
        commentId: commentDocid,
        datePublished: DateTime.now(),
        profilePic: user.profilePic!,
        likes: [],
      );

      await firestore
          .collection('testimonis')
          .doc(postId)
          .collection('comments')
          .doc(commentDocid)
          .set(commentModel.toMap());

      return right(commentModel);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<void> likeTheComments({
    required String testimonisId,
    required String commentDocid,
    required List likes,
    required String uid,
  }) async {
    try {
      if (likes.contains(uid)) {
        await firestore
            .collection('testimonis')
            .doc(testimonisId)
            .collection('comments')
            .doc(commentDocid)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await firestore
            .collection('testimonis')
            .doc(testimonisId)
            .collection('comments')
            .doc(commentDocid)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {}
  }

  Stream<List<CommentModel>> getComments({
    required String postId,
  }) {
    return firestore
        .collection('testimonis')
        .doc(postId)
        .collection('comments')
        .orderBy('datePublished', descending: true)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => CommentModel.fromMap(e.data())).toList(),
        );
  }
}
