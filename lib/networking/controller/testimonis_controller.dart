import 'package:digital_counter/models/comment_model.dart';
import 'package:digital_counter/models/testimonis_model.dart';
import 'package:digital_counter/networking/repository/testimonis_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final testimonisControllerProvider =
    StateNotifierProvider<TestimonisController, bool>((ref) {
  return TestimonisController(
    testimonisRepository: ref.watch(testimonisRepositoryProvider),
  );
});

final getAllTestimonisModelFromFirebaseProvider = StreamProvider((ref) {
  final testController = ref.watch(testimonisControllerProvider.notifier);
  return testController.getAllTestimonisModelFromFirebase();
});

final getCommentsProvider = StreamProvider.family((ref, String postId) {
  final testController = ref.watch(testimonisControllerProvider.notifier);
  return testController.getComments(postId: postId);
});

class TestimonisController extends StateNotifier<bool> {
  final TestimonisRepository testimonisRepository;

  TestimonisController({
    required this.testimonisRepository,
  }) : super(false);

  void shareImageTweet({
    required XFile images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
    required WidgetRef ref,
  }) async {
    state = true;
    final res = await testimonisRepository.shareImageTweet(
      images: images,
      text: text,
      context: context,
      repliedTo: repliedTo,
      repliedToUserId: repliedToUserId,
      ref: ref,
    );

    state = false;

    res.fold(
      (l) => null,
      (r) => Navigator.of(context).pop(),
    );
  }

  void shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
    required WidgetRef ref,
  }) async {
    state = true;
    final res = await testimonisRepository.shareTextTweet(
      text: text,
      context: context,
      repliedTo: repliedTo,
      repliedToUserId: repliedToUserId,
      ref: ref,
    );

    state = false;

    res.fold(
      (l) => null,
      (r) => Navigator.of(context).pop(),
    );
  }

  Stream<List<TestimonisModel>> getAllTestimonisModelFromFirebase() {
    return testimonisRepository.getAllTestimonisModelFromFirebase();
  }

  Future<void> likeThePost({
    required String testimonisId,
    required List likes,
    required String uid,
  }) async {
    await testimonisRepository.likeThePost(
      testimonisId: testimonisId,
      likes: likes,
      uid: uid,
    );
  }

  void postComment({
    required String postId,
    required String text,
    required WidgetRef ref,
  }) async {
    final res = await testimonisRepository.postComment(
      postId: postId,
      text: text,
      ref: ref,
    );

    res.fold(
      (l) => null,
      (r) => null,
    );
  }

  Stream<List<CommentModel>> getComments({
    required String postId,
  }) {
    return testimonisRepository.getComments(
      postId: postId,
    );
  }

  Future<void> likeTheComments({
    required String testimonisId,
    required String commentDocid,
    required List likes,
    required String uid,
  }) async {
    return await testimonisRepository.likeTheComments(
      testimonisId: testimonisId,
      commentDocid: commentDocid,
      likes: likes,
      uid: uid,
    );
  }
}
