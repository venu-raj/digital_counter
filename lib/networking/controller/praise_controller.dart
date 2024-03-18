import 'package:digital_counter/utils/common/utils.dart';
import 'package:digital_counter/features/home/screens/tabbar_screen.dart';
import 'package:digital_counter/models/praise_model.dart';
import 'package:digital_counter/models/user_model.dart';
import 'package:digital_counter/networking/repository/praise_repository.dart';
import 'package:digital_counter/features/auth/screens/user_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final praiseControllerProvider =
    StateNotifierProvider<PraiseController, bool>((ref) {
  return PraiseController(
    praiseRepository: ref.watch(praiseRepositoryProvider),
  );
});

final getPraiseFromFirebaseProvider = StreamProvider((ref) {
  return ref.watch(praiseControllerProvider.notifier).getPraiseFromFirebase();
});

final authStateChangeProvider = StreamProvider((ref) {
  return ref.watch(praiseControllerProvider.notifier).authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(praiseControllerProvider.notifier).getUserData(uid);
});

class PraiseController extends StateNotifier<bool> {
  final PraiseRepository praiseRepository;

  PraiseController({
    required this.praiseRepository,
  }) : super(false);

  Stream<User?> get authStateChange => praiseRepository.authStateChange;

  void loginWithUser({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    await praiseRepository.loginWithUser(
      phoneNumber: phoneNumber,
      context: context,
    );
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
    required WidgetRef ref,
  }) async {
    state = true;
    final res = await praiseRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
    state = false;

    res.fold(
      (l) => showSnackBar(context, l.toString(), ref),
      (r) => Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (context) => const UserDetailsScreen(),
        ),
        (route) => false,
      ),
    );
  }

  void uploadUserToFirebase({
    required String name,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final res = await praiseRepository.uploadUserToFirebase(name: name);

    res.fold(
      (l) => showSnackBar(context, l.toString(), ref),
      (r) => Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (context) => const TabbarScreen(),
        ),
        (route) => false,
      ),
    );
  }

  Stream<List<PraiseModel>> getPraiseFromFirebase() {
    return praiseRepository.getPraiseFromFirebase();
  }

  Stream<UserModel?> getUserData(String uid) {
    return praiseRepository.getUserData(uid);
  }

  void uploadPraiseToFirebase({
    required String name,
    required int num,
    required BuildContext context,
    required String id,
    required String relation,
    required String amount,
    required WidgetRef ref,
  }) async {
    final res = await praiseRepository.uploadPraiseToFirebase(
      name: name,
      num: num,
      id: id,
      relation: relation,
      amount: amount,
    );

    res.fold(
      (l) => showSnackBar(context, l.toString(), ref),
      (r) => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const TabbarScreen(),
        ),
        (route) => false,
      ),
    );
  }

  void updatePraiseModel(
    String uid,
    String name,
    int num,
    BuildContext context,
    WidgetRef ref,
  ) async {
    final res = await praiseRepository.updatePraiseModel(
      uid,
      name,
      num,
    );

    res.fold(
      (l) => showSnackBar(context, l.toString(), ref),
      (r) => null,
    );
  }

  void delectPraise(String id) async {
    return await praiseRepository.delectPraise(id);
  }

  void updateUser(
    String docId,
    String? name,
    XFile? profilePic,
    WidgetRef ref,
    BuildContext context,
  ) async {
    state = true;
    final res = await praiseRepository.updateUser(
      docId,
      name,
      profilePic,
      ref,
    );

    state = false;

    res.fold(
      (l) => showSnackBar(context, l.toString(), ref),
      (r) => Navigator.of(context).pop(),
    );
  }

  void updateUserNameOnly(
    String docId,
    String? name,
    WidgetRef ref,
    BuildContext context,
  ) async {
    state = true;
    final res = await praiseRepository.updateUserNameOnly(
      docId,
      name,
      ref,
    );

    state = false;

    res.fold(
      (l) => showSnackBar(context, l.toString(), ref),
      (r) => Navigator.of(context).pop(),
    );
  }

  void signOutUser() async {
    praiseRepository.signOutUser();
  }
}
