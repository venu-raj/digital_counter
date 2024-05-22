import 'package:flutter/material.dart';

class HowToAddPraiseScreen extends StatelessWidget {
  const HowToAddPraiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("How to Offer Praises."),
            Text("1. Offer Praise to God in One Acord in Spirit"),
            Text("2. One Acord in Flesh"),
            Text("3. By Having Faith"),
            Text("4. By filling in Sprit"),
            Text("5. By Appointing a Particular Time"),
            Text("6. In an Appointed Place"),
            Text("7. For an Particular Day."),
            Text("Ex: 30 Days, 60 Days & 90 Days"),
          ],
        ),
      ),
    );
  }
}
