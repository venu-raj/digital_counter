import 'package:digital_counter/common/utils.dart';
import 'package:digital_counter/models/praise_model.dart';
import 'package:digital_counter/models/user_model.dart';
import 'package:digital_counter/networking/repository/praise_repository.dart';
import 'package:digital_counter/home/screens/saved_praise_screen.dart';
import 'package:digital_counter/auth/screens/user_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    state = true;
    await praiseRepository.loginWithUser(
      phoneNumber: phoneNumber,
      context: context,
    );
    state = false;
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    state = true;
    final res = await praiseRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
    state = false;

    res.fold(
      (l) => showSnackBar(context, l.toString()),
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
  }) async {
    final res = await praiseRepository.uploadUserToFirebase(name: name);

    res.fold(
      (l) => showSnackBar(context, l.toString()),
      (r) => null,

      // Navigator.of(context).pushAndRemoveUntil(
      //   CupertinoPageRoute(
      //     builder: (context) => const AddPraiseScreen(),
      //   ),
      //   (route) => false,
      // ),
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
  }) async {
    final res = await praiseRepository.uploadPraiseToFirebase(
      name: name,
      num: num,
      id: id,
      relation: relation,
      amount: amount,
    );

    res.fold(
      (l) => showSnackBar(context, l.toString()),
      (r) => Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (context) => const SavedPraiseScreen(),
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
  ) async {
    final res = await praiseRepository.updatePraiseModel(
      uid,
      name,
      num,
    );

    res.fold(
      (l) => showSnackBar(context, l.toString()),
      (r) => null,
    );
  }

  void delectPraise(String id) async {
    return await praiseRepository.delectPraise(id);
  }
}
