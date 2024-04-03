import 'package:digital_counter/models/user_model.dart';
import 'package:flutter/material.dart';

Future<dynamic> showAdaptiveDialogForPrises(
  BuildContext context,
  UserModel user,
  TextEditingController controller,
  String relation,
  VoidCallback onPressed,
  ThemeData currentTheme,
) {
  return showAdaptiveDialog(
    context: context,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SizedBox(
            height: 300,
            child: AlertDialog(
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              elevation: 0,
              content: Column(
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter Name',
                    ),
                    maxLength: 30,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                        color: currentTheme.dividerColor,
                      )),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(relation,
                            style: Theme.of(context).textTheme.titleMedium!),
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
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: onPressed,
                  child: Text(
                    "Done",
                    style: TextStyle(color: currentTheme.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
