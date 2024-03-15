import 'package:digital_counter/home/screens/add_praise_screen_2.dart';
import 'package:digital_counter/home/screens/profile_screen.dart';
import 'package:digital_counter/home/screens/saved_praise_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabbarScreen extends StatefulWidget {
  const TabbarScreen({super.key});

  @override
  State<TabbarScreen> createState() => _TabbarScreenState();
}

class _TabbarScreenState extends State<TabbarScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          SavedPraiseScreen(),
          AddPraiseScreen2(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: index == 0
                ? const Icon(
                    CupertinoIcons.house_fill,
                    color: Colors.black,
                  )
                : Icon(
                    CupertinoIcons.home,
                    color: Colors.grey.withOpacity(0.7),
                  ),
          ),
          BottomNavigationBarItem(
            icon: index == 1
                ? const Icon(
                    CupertinoIcons.plus_rectangle_fill,
                    color: Colors.black,
                  )
                : Icon(
                    CupertinoIcons.plus_rectangle,
                    color: Colors.grey.withOpacity(0.7),
                  ),
          ),
          BottomNavigationBarItem(
            icon: index == 2
                ? const Icon(
                    CupertinoIcons.person_crop_circle_fill,
                    color: Colors.black,
                  )
                : Icon(
                    CupertinoIcons.profile_circled,
                    color: Colors.grey.withOpacity(0.7),
                  ),
          ),
        ],
      ),
    );
  }
}
