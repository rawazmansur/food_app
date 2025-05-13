import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;
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
  Color get textContainer => isDarkMode.value
      ? const Color.fromARGB(255, 255, 255, 255)
      : const Color.fromARGB(255, 255, 255, 255);
      Color get cardColor => isDarkMode.value
    ? const Color.fromARGB(255, 41, 41, 41) 
    : const Color.fromARGB(255, 245, 245, 245);


  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  void toggleTheme() {
    isDarkMode.toggle();
    _saveThemeToPrefs();
    update();
  }

  Future<void> swapTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isDarkMode.value == false) {
      isDarkMode.value = true;
      prefs.setBool('theme', true);
    } else {
      isDarkMode.value = false;
      prefs.setBool('theme', false);
    }
    update();
  }

  Future<void> _saveThemeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', isDarkMode.value);
  }

 Future<void> _loadThemeFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool savedTheme = prefs.getBool('theme') ?? false; // Use false if null
  isDarkMode.value = savedTheme;
  update();
}

}