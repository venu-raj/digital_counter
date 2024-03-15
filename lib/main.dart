import 'package:digital_counter/common/loader.dart';
import 'package:digital_counter/firebase_options.dart';
import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:digital_counter/models/user_model.dart';
import 'package:digital_counter/auth/screens/login_screen.dart';
import 'package:digital_counter/home/screens/tabbar_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(praiseControllerProvider.notifier)
        .getUserData(data.uid)
        .first;

    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ref.watch(authStateChangeProvider).when(
            data: (user) {
              if (user != null) {
                getData(ref, user);
                if (userModel != null) {
                  return const TabbarScreen();
                }
              }
              return const LoginScreen();
            },
            error: (error, st) {
              return Center(
                child: Text(error.toString()),
              );
            },
            loading: () => const Loader(),
          ),
    );
  }
}
