import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController with WidgetsBindingObserver {
  RxBool isDarkMode = false.obs;
  RxString themeSource = 'system'.obs; // system, light, dark

  Color get appBar => isDarkMode.value
      ? const Color.fromARGB(255, 51, 51, 51)
      : const Color.fromARGB(255, 255, 255, 255);
  Color get scaffold => isDarkMode.value
      ? const Color.fromARGB(255, 51, 51, 51)
      : const Color.fromARGB(255, 255, 255, 255);
  Color get textAppBar => isDarkMode.value
      ? const Color.fromARGB(255, 255, 255, 255)
      : const Color.fromARGB(255, 39, 84, 138);
  Color get iconBottonNav => isDarkMode.value
      ? const Color.fromARGB(255, 116, 166, 252)
      : const Color.fromARGB(255, 116, 166, 252);
  Color get textNumbers => isDarkMode.value
      ? const Color.fromARGB(255, 51, 51, 51)
      : const Color.fromARGB(255, 39, 84, 138);
  Color get textContainer => const Color.fromARGB(255, 255, 255, 255);
  Color get cardColor => isDarkMode.value
      ? const Color.fromARGB(255, 41, 41, 41)
      : const Color.fromARGB(255, 245, 245, 245);
  Color get storyContainer => isDarkMode.value
      ? const Color.fromARGB(255, 36, 36, 36)
      : const Color.fromARGB(255, 255, 255, 255);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _loadThemeFromPrefs();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  // Listen to system brightness changes
  @override
  void didChangePlatformBrightness() {
    if (themeSource.value == 'system') {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      isDarkMode.value = brightness == Brightness.dark;
      update();
    }
  }

  // Set theme manually or system
  Future<void> setTheme(String mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    themeSource.value = mode;

    if (mode == 'system') {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      isDarkMode.value = brightness == Brightness.dark;
    } else if (mode == 'dark') {
      isDarkMode.value = true;
    } else if (mode == 'light') {
      isDarkMode.value = false;
    }

    await prefs.setString('themeSource', mode);
    if (mode != 'system') {
      await prefs.setBool('theme', isDarkMode.value);
    }

    update();
  }

  Future<void> toggleTheme() async {
    if (themeSource.value == 'system') {
      // If system, switch to manual dark mode
      await setTheme('dark');
    } else if (themeSource.value == 'dark') {
      await setTheme('light');
    } else {
      await setTheme('dark');
    }
  }

  Future<void> _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedSource = prefs.getString('themeSource') ?? 'system';
    themeSource.value = savedSource;

    if (savedSource == 'system') {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      isDarkMode.value = brightness == Brightness.dark;
    } else {
      bool savedTheme = prefs.getBool('theme') ?? false;
      isDarkMode.value = savedTheme;
    }

    update();
  }
}
