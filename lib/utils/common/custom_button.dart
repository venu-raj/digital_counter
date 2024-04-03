import 'package:flutter/material.dart';

import 'package:digital_counter/utils/theme/pallete.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.currentTheme,
    required this.onpressed,
    required this.text,
    required this.width,
  });

  final ThemeData currentTheme;
  final VoidCallback onpressed;
  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Pallete.blueColor,
        minimumSize: Size(width, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: currentTheme.scaffoldBackgroundColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
