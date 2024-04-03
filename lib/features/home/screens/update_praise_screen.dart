import 'package:digital_counter/utils/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_counter/features/home/screens/add_praise_screen.dart';
import 'package:digital_counter/features/home/screens/tabbar_screen.dart';
import 'package:digital_counter/features/home/widgets/show_adaptive_dialog_for_prises.dart';
import 'package:digital_counter/models/praise_model.dart';
import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:digital_counter/utils/common/custom_button.dart';
import 'package:digital_counter/utils/common/utils.dart';
import 'package:digital_counter/utils/theme/app_theme.dart';

class UpdatePraiseScreen extends ConsumerStatefulWidget {
  final PraiseModel praiseModel;
  const UpdatePraiseScreen({
    super.key,
    required this.praiseModel,
  });

  @override
  ConsumerState<UpdatePraiseScreen> createState() => _UpdatePraiseScreenState();
}

class _UpdatePraiseScreenState extends ConsumerState<UpdatePraiseScreen> {
  late int value;
  late TextEditingController controller;

  @override
  void initState() {
    value = widget.praiseModel.num;
    controller = TextEditingController(text: widget.praiseModel.name);
    super.initState();
  }

  void updatePraiseModel() {
    ref.watch(praiseControllerProvider.notifier).updatePraiseModel(
          widget.praiseModel.id,
          controller.text.trim(),
          value,
          context,
          ref,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(),
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
                        "Target - ${widget.praiseModel.amount}",
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "For - ${widget.praiseModel.relation}",
                        style: Theme.of(context).textTheme.titleMedium,
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
                text: "Save",
                width: MediaQuery.of(context).size.width,
                currentTheme: currentTheme,
                onpressed: () {
                  if (value >= 1) {
                    showAdaptiveDialogForPrises(
                      context,
                      user,
                      controller,
                      widget.praiseModel.relation,
                      () {
                        if (controller.text.trim().isNotEmpty && value != 0) {
                          updatePraiseModel();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const TabbarScreen(),
                              ),
                              (route) => false);
                        } else {
                          showSnackBar(
                            context,
                            "Name must be provided and value must be greater than 1",
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
