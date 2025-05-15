import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:get/get.dart';

class SuggestionPage extends StatefulWidget {
  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _suggestionController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ThemeController themeController = Get.find();

  void _submitSuggestion() async {
    String name = _nameController.text.trim();
    String suggestion = _suggestionController.text.trim();

    if (name.isEmpty || suggestion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تکایە ناو و پێشنیارەکەت پڕبکەوە',
            style: TextStyle(fontFamily: 'ZainPeet'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await _firestore.collection('suggestions').add({
      'name': name,
      'suggestion': suggestion,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _nameController.clear();
    _suggestionController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'سوپاس بۆ پێشنیارەکەت ئێمە بەرزدەینرخێنین!',
          style: TextStyle(fontFamily: 'ZainPeet'),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: themeController.scaffold,
        appBar: AppBar(
          backgroundColor: themeController.scaffold,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: themeController.textAppBar),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'پێشنیار و ڕاوبۆچوون',
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: 'ZainPeet',
              color: themeController.textAppBar,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'ZainPeet',
                  color: themeController.textAppBar,
                ),
                decoration: InputDecoration(
                  labelText: 'ناوی بەڕێزتان',
                  labelStyle: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'ZainPeet',
                    color: themeController.textAppBar,
                  ),
                  filled: true,
                  fillColor: themeController.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _suggestionController,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'ZainPeet',
                  color: themeController.textAppBar,
                ),
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'پێشنیارەکەت',
                  labelStyle: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'ZainPeet',
                    color: themeController.textAppBar,
                  ),
                  filled: true,
                  fillColor: themeController.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _submitSuggestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeController.iconBottonNav,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    'ناردن',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: 'ZainPeet',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
