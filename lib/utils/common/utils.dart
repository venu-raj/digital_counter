import 'package:digital_counter/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String content, WidgetRef ref) {
  final currentTheme = ref.watch(themeNotifierProvider);

  ScaffoldMessenger.of(context)
    ..hideCurrentMaterialBanner()
    ..showSnackBar(
      SnackBar(
        backgroundColor: currentTheme.cardColor,
        content: Text(
          content,
          style: TextStyle(
            color: currentTheme.primaryColor,
          ),
        ),
      ),
    );
}

Future pickImage() async {
  final ImagePicker picker = ImagePicker();
  XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    return image;
  }
}

void showAlertDialog({
  required BuildContext context,
  required String title,
  required VoidCallback onTap1,
  required String button1Text,
  required Color textColor,
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
            child: Text(
              button1Text,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: onTap2,
            child: Text(
              button2Text ?? "",
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      );
    },
  );
}
