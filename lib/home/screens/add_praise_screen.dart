import 'package:digital_counter/home/screens/tabbar_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_counter/common/utils.dart';
import 'package:digital_counter/networking/controller/praise_controller.dart';
import 'package:digital_counter/home/widgets/digital_number.dart';

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

  void saveUserData(id) {
    ref.watch(praiseControllerProvider.notifier).uploadPraiseToFirebase(
          name: namecontroller.text.trim(),
          num: value,
          context: context,
          id: id,
          relation: widget.relation,
          amount: widget.amount,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

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
                    if (value >= 1) {
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
                    }
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
                          content: Column(
                            children: [
                              TextField(
                                controller: namecontroller,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Name',
                                ),
                                maxLength: 15,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.black),
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.relation,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(color: Colors.black54),
                                    ),
                                  ),
                                ),
                              )
                            ],
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
                                if (namecontroller.text.trim().isNotEmpty &&
                                    value != 0) {
                                  saveUserData(user.uid);
                                  Navigator.of(context).pushAndRemoveUntil(
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            const TabbarScreen(),
                                      ),
                                      (route) => false);
                                } else {
                                  showSnackBar(
                                    context,
                                    "Name must be provided and value must be greater than 1",
                                  );
                                }
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
                  ),
                ),
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

class DigitalNumberWidget extends StatelessWidget {
  final int value;
  const DigitalNumberWidget({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          DigitalNumber(
            key: GlobalKey(),
            value: value,
            height: 50,
            color: Colors.black,
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

class DigitalNumberWidgetForEmpty extends StatelessWidget {
  final int value;
  const DigitalNumberWidgetForEmpty({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          DigitalNumber(
            key: GlobalKey(),
            value: value,
            height: 50,
            color: Colors.black.withOpacity(0.04),
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
