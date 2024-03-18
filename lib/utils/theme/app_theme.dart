import 'package:digital_counter/utils/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class AppTheme {
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.blackColor,
    cardColor: const Color.fromARGB(163, 44, 44, 45),
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.blackColor,
      iconTheme: IconThemeData(
        color: Pallete.whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Pallete.drawerColor,
    ),
    primaryColor: Pallete.whiteColor,
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Pallete.whiteColor,
    cardColor: Pallete.drawerColor.withOpacity(0.15),
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Pallete.blackColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Pallete.whiteColor,
    ),
    primaryColor: Pallete.blackColor,
  );
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;
  ThemeNotifier({ThemeMode mode = ThemeMode.light})
      : _mode = mode,
        super(
          AppTheme.lightModeAppTheme,
        ) {
    getTheme();
  }

  ThemeMode get mode => _mode;

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');

    if (theme == 'light') {
      _mode = ThemeMode.light;
      state = AppTheme.lightModeAppTheme;
    } else {
      _mode = ThemeMode.dark;
      state = AppTheme.darkModeAppTheme;
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = AppTheme.lightModeAppTheme;
      prefs.setString('theme', 'light');
    } else {
      _mode = ThemeMode.dark;
      state = AppTheme.darkModeAppTheme;
      prefs.setString('theme', 'dark');
    }
  }
}
