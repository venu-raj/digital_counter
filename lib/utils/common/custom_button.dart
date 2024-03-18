import 'package:digital_counter/utils/theme/pallete.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.currentTheme,
    required this.onpressed,
    required this.text,
  });

  final ThemeData currentTheme;
  final VoidCallback onpressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Pallete.blueColor,
        minimumSize: Size(MediaQuery.of(context).size.width, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: currentTheme.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
