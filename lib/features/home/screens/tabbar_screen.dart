import 'package:digital_counter/features/daily_verse/daily_verse_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_counter/features/home/screens/saved_praise_screen.dart';
import 'package:digital_counter/features/profile/profile_screen.dart';
import 'package:digital_counter/features/testimonis/screens/testimonis_feed_screen.dart';
import 'package:digital_counter/utils/theme/app_theme.dart';

class TabbarScreen extends ConsumerStatefulWidget {
  const TabbarScreen({
    super.key,
  });

  @override
  ConsumerState<TabbarScreen> createState() => _TabbarScreenState();
}

class _TabbarScreenState extends ConsumerState<TabbarScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          SavedPraiseScreen(),
          TestmonisFeedScreen(),
          DailyVerseScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: index == 0
                ? Icon(
                    CupertinoIcons.house_fill,
                    color: currentTheme.primaryColor,
                  )
                : Icon(
                    CupertinoIcons.home,
                    color: currentTheme.dividerColor,
                  ),
          ),
          BottomNavigationBarItem(
            icon: index == 1
                ? Icon(
                    Icons.group,
                    size: 33,
                    color: currentTheme.primaryColor,
                  )
                : Icon(
                    Icons.group_outlined,
                    size: 35,
                    color: currentTheme.dividerColor,
                  ),
          ),
          BottomNavigationBarItem(
            icon: index == 2
                ? Icon(
                    Icons.menu_book_rounded,
                    color: currentTheme.primaryColor,
                  )
                : Icon(
                    Icons.menu_book_rounded,
                    color: currentTheme.dividerColor,
                  ),
          ),
          BottomNavigationBarItem(
            icon: index == 3
                ? Icon(
                    CupertinoIcons.person_crop_circle_fill,
                    color: currentTheme.primaryColor,
                  )
                : Icon(
                    CupertinoIcons.profile_circled,
                    color: currentTheme.dividerColor,
                  ),
          ),
        ],
      ),
    );
  }
}
