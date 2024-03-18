import 'package:digital_counter/utils/common/custom_button.dart';
import 'package:digital_counter/features/home/screens/tabbar_screen.dart';
import 'package:digital_counter/features/home/widgets/show_adaptive_dialog_for_prises.dart';
import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:digital_counter/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_counter/utils/common/utils.dart';
import 'package:digital_counter/models/praise_model.dart';
import 'package:digital_counter/features/home/screens/add_praise_screen.dart';

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
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Target - ${widget.praiseModel.amount}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "To - ${widget.praiseModel.relation}",
                  style: Theme.of(context).textTheme.titleMedium,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
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
                  },
                  child: Image.asset(
                    "assets/counterbutton.png",
                    height: 60,
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      value += 1;
                    });
                  },
                  child: Image.asset(
                    "assets/counterbutton.png",
                    height: 120,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CustomButton(
                text: "Save",
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
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
