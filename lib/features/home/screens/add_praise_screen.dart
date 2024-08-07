import 'package:digital_counter/features/home/screens/how_to_add_praise_screen.dart';
import 'package:digital_counter/features/home/screens/tabbar_screen.dart';
import 'package:digital_counter/utils/common/custom_button.dart';
import 'package:digital_counter/features/home/widgets/show_adaptive_dialog_for_prises.dart';
import 'package:digital_counter/utils/theme/app_theme.dart';
import 'package:digital_counter/utils/theme/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_counter/utils/common/utils.dart';
import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:digital_counter/features/home/widgets/digital_number.dart';

class AddPraiseScreen extends ConsumerStatefulWidget {
  final String relation;
  final String amount;
  const AddPraiseScreen({
    super.key,
    required this.relation,
    required this.amount,
  });

  @override
  ConsumerState<AddPraiseScreen> createState() => _AddPraiseScreenState();
}

class _AddPraiseScreenState extends ConsumerState<AddPraiseScreen> {
  int value = 0;
  final namecontroller = TextEditingController();

  @override
  void dispose() {
    namecontroller.dispose();
    super.dispose();
  }

  void saveUserData(id) {
    ref.watch(praiseControllerProvider.notifier).uploadPraiseToFirebase(
          name: namecontroller.text.trim(),
          num: value,
          context: context,
          id: id,
          relation: widget.relation,
          amount: widget.amount,
          ref: ref,
        );
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const TabbarScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => const HowToAddPraiseScreen(),
                ),
              );
            },
            child: const Text("See How to Praise"),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(
              flex: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    value += 30;
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/counterbutton.png",
                        height: 80,
                      ),
                      Text(
                        "Auto",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: currentTheme.primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Target - ${widget.amount}",
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "For ${widget.relation}",
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (value >= 1) {
                      showAlertDialog(
                        context: context,
                        title: "Are you sure want to reset?",
                        onTap1: () {
                          Navigator.of(context).pop();
                        },
                        button1Text: "Cancel",
                        textColor: currentTheme.primaryColor,
                        onTap2: () {
                          setState(() {
                            value = 0;
                          });
                          Navigator.of(context).pop();
                        },
                        button2Text: "Yes",
                      );
                    }
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/counterbutton.png",
                        height: 80,
                      ),
                      Text(
                        "Reset",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: currentTheme.primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: value <= 9
                        ? Row(
                            children: [
                              const DigitalNumberWidgetForEmpty(value: 8),
                              const DigitalNumberWidgetForEmpty(value: 8),
                              const DigitalNumberWidgetForEmpty(value: 8),
                              DigitalNumberWidget(value: value)
                            ],
                          )
                        : value <= 99
                            ? Row(
                                children: [
                                  const DigitalNumberWidgetForEmpty(value: 8),
                                  const DigitalNumberWidgetForEmpty(value: 8),
                                  DigitalNumberWidget(value: value)
                                ],
                              )
                            : value <= 999
                                ? Row(
                                    children: [
                                      const DigitalNumberWidgetForEmpty(
                                          value: 8),
                                      DigitalNumberWidget(value: value)
                                    ],
                                  )
                                : DigitalNumberWidget(value: value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      value += 1;
                    });
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/counterbutton.png",
                        height: 120,
                      ),
                      Positioned(
                        bottom: 50,
                        right: 15,
                        child: Text(
                          "Count/Pause",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Pallete.blackColor),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CustomButton(
                width: MediaQuery.of(context).size.width,
                text: "Save",
                currentTheme: currentTheme,
                onpressed: () {
                  if (value >= 1) {
                    showAdaptiveDialogForPrises(
                      context,
                      user,
                      namecontroller,
                      widget.relation,
                      () {
                        if (namecontroller.text.trim().isNotEmpty) {
                          saveUserData(user.uid);
                        } else {
                          showSnackBar(
                            context,
                            "Name should not be empty",
                            ref,
                          );
                        }
                      },
                      currentTheme,
                    );
                  } else {
                    showSnackBar(
                      context,
                      "The amount must be greater than or equal to 1",
                      ref,
                    );
                  }
                },
              ),
            ),
            const Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class DigitalNumberWidget extends ConsumerWidget {
  final int value;
  const DigitalNumberWidget({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          DigitalNumber(
            key: GlobalKey(),
            value: value,
            height: 50,
            color: currentTheme.primaryColor,
          ),
          DigitalNumber(
            key: GlobalKey(),
            value: value <= 9
                ? 8
                : value <= 99
                    ? 88
                    : value <= 999
                        ? 888
                        : 8888,
            height: 50,
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),
    );
  }
}

class DigitalNumberWidgetForEmpty extends ConsumerWidget {
  final int value;
  const DigitalNumberWidgetForEmpty({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          DigitalNumber(
            key: GlobalKey(),
            value: value,
            height: 50,
            color: currentTheme.primaryColor.withOpacity(0.04),
          ),
          DigitalNumber(
            key: GlobalKey(),
            value: value <= 9
                ? 8
                : value <= 99
                    ? 88
                    : value <= 999
                        ? 888
                        : 8888,
            height: 50,
            color: currentTheme.primaryColor.withOpacity(0.04),
          ),
        ],
      ),
    );
  }
}
