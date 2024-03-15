import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_counter/models/user_model.dart';
import 'package:digital_counter/auth/screens/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:digital_counter/models/praise_model.dart';
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

  loginWithUser({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    try {
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

  Stream<UserModel?> getUserData(String uid) {
    return firestore.collection('users').doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
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
}
