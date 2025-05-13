import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/FontSizeController.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:get/get.dart';

class ContentText extends StatelessWidget {
  final String text;

  ContentText({required this.text});

  final ThemeController _themeController = Get.find();
  final FontSizeController fontSizeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.justify,
      textDirection: TextDirection.rtl,
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSizeController.kurdishFontSize.value,
          fontFamily: 'ZainPeet',
          color: _themeController.textAppBar,
          height: 1.8,
        ),
        children: _getStyledText(text),
      ),
    );
  }

    List<TextSpan> _getStyledText(String text) {
    final themeController = Get.find<ThemeController>();

    final hadithRegex = RegExp(r'(\uFDFA|\uFDFF|\uFDFE)');
    final vitaminRegex = RegExp(r'\s?[A-Z0-9]+\b', caseSensitive: false);

    List<TextSpan> spans = [];

    final splitText = text.splitMapJoin(
      RegExp(r'(\s+)'),
      onMatch: (m) => '|||${m.group(0)}|||',
      onNonMatch: (n) => '|||$n|||',
    ).split('|||');

    for (var segment in splitText) {
      if (segment.trim().isEmpty) {
        spans.add(TextSpan(text: segment));
        continue;
      }

      // ✅ Vitamin match (e.g., Vitamin A, B12, C, D3...)
      if (vitaminRegex.hasMatch(segment)) {
        spans.add(
          TextSpan(
            text: segment,
            style: TextStyle(
                fontSize: fontSizeController.kurdishFontSize.value,
              fontFamily: 'ZainPeet',
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }

      // Hadith symbol ﷺ
      else if (hadithRegex.hasMatch(segment)) {
        spans.add(
          TextSpan(
            text: segment,
            style: TextStyle(
                fontSize: fontSizeController.kurdishFontSize.value,
              fontFamily: 'ZainPeet',
              color: Colors.red,
            ),
          ),
        );
      }

      // Default style
      else {
        spans.add(
          TextSpan(
            text: segment,
          ),
        );
      }
    }

    return spans;
  }

}
