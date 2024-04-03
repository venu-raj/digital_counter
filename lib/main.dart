import 'package:digital_counter/features/notifications/notifications.dart';
import 'package:digital_counter/models/user_model.dart';
import 'package:digital_counter/utils/common/loader.dart';
import 'package:digital_counter/firebase_options.dart';
import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:digital_counter/features/auth/screens/login_screen.dart';
import 'package:digital_counter/features/home/screens/tabbar_screen.dart';
import 'package:digital_counter/utils/common/utils.dart';
import 'package:digital_counter/utils/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.notification != null) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationsRepository().init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref) async {
    userModel =
        await ref.watch(praiseControllerProvider.notifier).getUserData().first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return PopScope(
      onPopInvoked: (didPop) {
        return showAlertDialog(
          context: context,
          title: "Are you sure want to exit the app",
          onTap1: () {
            didPop = false;
            Navigator.of(context).pop();
          },
          button1Text: "No",
          textColor: currentTheme.primaryColor,
          button2Text: "Yes",
          onTap2: () {
            didPop = true;
          },
        );
      },
      child: MaterialApp(
        title: 'Digital Counter',
        debugShowCheckedModeBanner: false,
        theme: ref.watch(themeNotifierProvider),
        home: ref.watch(userDataAuthProvider).when(
              data: (user) {
                if (user != null) {
                  getData(ref);
                  return const TabbarScreen();
                }
                return const LoginScreen();
              },
              error: (err, trace) {
                return Center(
                  child: Text(err.toString()),
                );
              },
              loading: () => const LoadingPage(),
            ),
        // home: ref.watch(authStateChangeProvider).when(
        //       data: (user) {
        //         if (user != null) {
        //           return const TabbarScreen();
        //         }
        //         return const LoginScreen();
        //       },
        //       error: (error, st) {
        //         return Center(
        //           child: Text(error.toString()),
        //         );
        //       },
        //       loading: () => const LoadingPage(),
        //     ),
      ),
    );
  }
}
