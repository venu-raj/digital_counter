import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_counter/features/testimonis/screens/add_testimonis_screen.dart';
import 'package:digital_counter/features/testimonis/widgets/testimonis_card.dart';
import 'package:digital_counter/networking/controller/testimonis_controller.dart';
import 'package:digital_counter/utils/common/loader.dart';
import 'package:digital_counter/utils/theme/app_theme.dart';
import 'package:digital_counter/utils/theme/pallete.dart';

class TestmonisFeedScreen extends ConsumerStatefulWidget {
  const TestmonisFeedScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TestmonisFeedScreenState();
}

class _TestmonisFeedScreenState extends ConsumerState<TestmonisFeedScreen> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Testimonies"),
        centerTitle: false,
      ),
      body: ref.watch(getAllTestimonisModelFromFirebaseProvider).when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final testmonis = data[index];
              return TestimonisCard(
                testimonisModel: testmonis,
              );
            },
          );
        },
        error: (error, st) {
          return Center(
            child: Text(error.toString()),
          );
        },
        loading: () {
          return const LoadingPage();
        },
      ),
      floatingActionButton: user!.isAdmin
          ? FloatingActionButton(
              heroTag: "btn2",
              backgroundColor: Pallete.greenColor,
              foregroundColor: currentTheme.scaffoldBackgroundColor,
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const AddTestimonisScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.post_add_rounded,
                color: Pallete.whiteColor,
              ),
            )
          : null,
    );
  }
}
