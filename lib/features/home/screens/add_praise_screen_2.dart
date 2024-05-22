import 'package:digital_counter/utils/common/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_counter/utils/common/utils.dart';
import 'package:digital_counter/features/home/screens/add_praise_screen.dart';
import 'package:digital_counter/utils/theme/app_theme.dart';

class AddPraiseScreen2 extends ConsumerStatefulWidget {
  const AddPraiseScreen2({super.key});

  @override
  ConsumerState<AddPraiseScreen2> createState() => _AddPraiseScreen2State();
}

class _AddPraiseScreen2State extends ConsumerState<AddPraiseScreen2> {
  final amountController = TextEditingController();
  final reasonController = TextEditingController();
  @override
  void dispose() {
    amountController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 1),
          Text(
            "Start a new Praise",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: reasonController,
              decoration: InputDecoration(
                hintText: "Praises For",
                focusColor: currentTheme.dividerColor,
                hoverColor: currentTheme.dividerColor,
              ),
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType: TextInputType.text,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: amountController,
              decoration: InputDecoration(
                hintText: "Praising Count",
                focusColor: currentTheme.dividerColor,
                hoverColor: currentTheme.dividerColor,
              ),
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomButton(
              text: "CONTINUE",
              currentTheme: currentTheme,
              width: MediaQuery.of(context).size.width,
              onpressed: () {
                if (amountController.text.trim().isNotEmpty &&
                    reasonController.text.trim().isNotEmpty) {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => AddPraiseScreen(
                        relation: reasonController.text.trim(),
                        amount: amountController.text.trim(),
                      ),
                    ),
                  );
                } else {
                  showSnackBar(context, "Please fill all the fields", ref);
                }
              },
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
