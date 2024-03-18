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
  String dropdownvalue = "Father";
  final amountController = TextEditingController();
  var items = [
    'Father',
    'Mother',
    'Sister',
    'Brother',
    'Friends',
    '+',
  ];

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "To who do you want to send praise",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton(
                value: dropdownvalue,
                icon: const Icon(Icons.arrow_downward),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(items),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.40,
                child: TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                    hintText: "Enter Amount",
                    focusColor: currentTheme.dividerColor,
                    hoverColor: currentTheme.dividerColor,
                  ),
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: CustomButton(
              text: "CONTINUE",
              currentTheme: currentTheme,
              onpressed: () {
                if (amountController.text.trim().isNotEmpty) {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => AddPraiseScreen(
                        relation: dropdownvalue,
                        amount: amountController.text.trim(),
                      ),
                    ),
                  );
                } else {
                  showSnackBar(context, "Please enter valid amount", ref);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
