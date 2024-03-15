import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

showAlertDialog({
  required BuildContext context,
  required String title,
  required VoidCallback onTap1,
  required String button1Text,
  VoidCallback? onTap2,
  String? button2Text,
}) {
  showAdaptiveDialog(
    context: context,
    builder: (context) {
      return AlertDialog.adaptive(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: onTap1,
            child: Text(button1Text),
          ),
          TextButton(
            onPressed: onTap2,
            child: Text(button2Text ?? ""),
          ),
        ],
      );
    },
  );
}
