import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSizeController extends GetxController {

  var kurdishFontSize = 16.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFontSizes();
  }

  void _loadFontSizes() async {
    final prefs = await SharedPreferences.getInstance();
    kurdishFontSize.value = prefs.getDouble('kurdishFontSize') ?? 16.0;
  }

  void updateArabicFontSize(double size) {
    _saveFontSizes();
    update();
  }

  void updateKurdishFontSize(double size) {
    kurdishFontSize.value = size;
    _saveFontSizes();
    update();
  }

  void _saveFontSizes() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('kurdishFontSize', kurdishFontSize.value);
  }
}