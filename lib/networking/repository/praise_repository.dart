import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_counter/models/user_model.dart';
import 'package:digital_counter/features/auth/screens/otp_screen.dart';
import 'package:digital_counter/networking/repository/storage_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:digital_counter/models/praise_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

final praiseRepositoryProvider = Provider<PraiseRepository>((ref) {
  return PraiseRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

class PraiseRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  PraiseRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<User?> get authStateChange => auth.authStateChanges();

  Future loginWithUser({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        throw Exception(e.message);
      },
      codeSent: ((String verificationId, int? resendToken) async {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => OTPScreen(verificationId: verificationId),
          ),
        );
      }),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<Either<String, UserCredential>> signInAsGuest() async {
    try {
      final res = await auth.signInAnonymously();

      return right(res);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, PhoneAuthCredential>> verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);

      return right(credential);
    } on FirebaseAuthException catch (e) {
      return left(e.code);
    }
  }

  Future<Either<String, UserModel>> uploadUserToFirebase({
    required String name,
  }) async {
    try {
      UserModel userModel = UserModel(
        phoneNumber: auth.currentUser!.phoneNumber.toString(),
        uid: auth.currentUser!.uid,
        name: name,
        profilePic:
            "https://firebasestorage.googleapis.com/v0/b/digital-counter-ae71e.appspot.com/o/default_profile_pic%2FScreenshot%201946-01-14%20at%2005.16.26.png?alt=media&token=3c93dead-b4c0-4930-98fa-e0e6cd69f636",
      );

      await firestore
          .collection("users")
          .doc(userModel.uid)
          .set(userModel.toMap());

      return right(userModel);
    } catch (e) {
      return left(e.toString());
    }
  }

  Stream<UserModel?> getUserData() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .snapshots()
        .map(
          (event) => UserModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  Future<Either<String, PraiseModel>> uploadPraiseToFirebase({
    required String name,
    required int num,
    required String id,
    required String relation,
    required String amount,
  }) async {
    try {
      final uuid = const Uuid().v1();

      PraiseModel praiseModel = PraiseModel(
        name: name,
        num: num,
        id: uuid,
        uid: id,
        dateCreated: DateTime.now(),
        relation: relation,
        amount: amount,
      );

      await firestore.collection("praises").doc(uuid).set(praiseModel.toMap());

      return right(praiseModel);
    } catch (e) {
      return left(e.toString());
    }
  }

  Stream<List<PraiseModel>> getPraiseFromFirebase() {
    try {
      return firestore
          .collection("praises")
          .where("uid", isEqualTo: auth.currentUser!.uid)
          .snapshots()
          .map(
            (event) => event.docs
                .map(
                  (e) => PraiseModel.fromMap(e.data()),
                )
                .toList(),
          );
    } catch (e) {
      throw Exception();
    }
  }

  Future<Either<String, void>> updatePraiseModel(
    String uid,
    String name,
    int num,
  ) async {
    try {
      final res = await firestore.collection("praises").doc(uid).update({
        "name": name,
        "num": num,
      });
      return right(res);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<void> delectPraise(String id) async {
    await firestore.collection("praises").doc(id).delete();
  }

  void signOutUser() async {
    await auth.signOut();
  }

  Future<Either<String, void>> updateUser(
    String docId,
    String? name,
    XFile? profilePic,
    WidgetRef ref,
  ) async {
    try {
      final profilePicstorage =
          await ref.watch(storageMethodsProvider).uploadImageToStorage(
                "profilePic",
                profilePic!,
                false,
              );
      final res = await firestore.collection('users').doc(docId).update({
        'name': name,
        'profilePic': profilePicstorage,
      });

      return right(res);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, void>> updateUserNameOnly(
    String docId,
    String? name,
    WidgetRef ref,
  ) async {
    try {
      final res =
          await firestore.collection('users').doc(docId).update({'name': name});

      return right(res);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }
}
