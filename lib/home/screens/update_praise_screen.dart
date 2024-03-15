import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_counter/common/utils.dart';
import 'package:digital_counter/models/praise_model.dart';
import 'package:digital_counter/home/screens/add_praise_screen.dart';

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
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey.shade100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: widget.praiseModel.num <= 9
                        ? Row(
                            children: [
                              const DigitalNumberWidgetForEmpty(value: 8),
                              const DigitalNumberWidgetForEmpty(value: 8),
                              const DigitalNumberWidgetForEmpty(value: 8),
                              DigitalNumberWidget(value: value)
                            ],
                          )
                        : widget.praiseModel.num <= 99
                            ? Row(
                                children: [
                                  const DigitalNumberWidgetForEmpty(value: 8),
                                  const DigitalNumberWidgetForEmpty(value: 8),
                                  DigitalNumberWidget(value: value)
                                ],
                              )
                            : widget.praiseModel.num <= 999
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return Scaffold(
                        body: AlertDialog.adaptive(
                          content: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                              hintText: 'Enter Name',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                updatePraiseModel();
                                Navigator.of(context).pop();
                              },
                              child: const Text("Done"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                child: Text(
                  "Save",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
