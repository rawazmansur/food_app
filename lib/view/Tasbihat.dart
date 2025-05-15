import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:food/controller/tasbih_controller.dart';
import 'package:food/view/widgets/CustomBottomNavigationBar.dart';

class Tasbihat extends StatefulWidget {
  const Tasbihat({super.key});

  @override
  State<Tasbihat> createState() => _TasbihatState();
}

class _TasbihatState extends State<Tasbihat> {
  final _themeController = Get.find<ThemeController>();
  final _tasbihController = Get.find<TasbihController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: _themeController.scaffold,
          appBar: AppBar(
            backgroundColor: _themeController.appBar,
            title: Text(
              'زیکرەکانم',
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'ZainPeet',
                color: _themeController.textAppBar,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(12.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Horizontal tasbih name selector
                SizedBox(
                  height: 50.sp,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _tasbihController.phrases.length,
                    itemBuilder: (context, index) {
                      final phrase = _tasbihController.phrases[index];
                      final isSelected =
                          _tasbihController.selectedPhrase.value == phrase;
                      return GestureDetector(
                        onTap: () {
                          _tasbihController.selectedPhrase.value = phrase;
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.sp),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.sp,
                            vertical: 10.sp,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? (_themeController.isDarkMode.value
                                        ? Colors.blueGrey
                                        : Colors.blueAccent)
                                    : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              phrase,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: 'ZainPeet',
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 30.sp),

                // Show selected tasbih counter
                if (_tasbihController.selectedPhrase.value.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.sp),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            _themeController.isDarkMode.value
                                ? [
                                  const Color.fromARGB(255, 41, 41, 41),
                                  const Color.fromARGB(255, 67, 67, 67),
                                ]
                                : const [
                                  Color.fromARGB(255, 166, 196, 247),
                                  Color.fromARGB(255, 116, 166, 252),
                                ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          _tasbihController.selectedPhrase.value,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontFamily: 'ZainPeet',
                            fontWeight: FontWeight.bold,
                            color: _themeController.textAppBar,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.sp),

                        // Beads Animation
                        // Beads Circle (33 Tasbih Beads)
                        SizedBox(
                          height: 180.sp,
                          width: 180.sp,
                          child: Stack(
                            alignment: Alignment.center,
                            children: List.generate(33, (index) {
                              final angle =
                                  (index * (360 / 33)) * 3.14 / 180; // Radians
                              final radius = 75.sp;

                              final current =
                                  _tasbihController
                                      .phraseCounters[_tasbihController
                                          .selectedPhrase
                                          .value]
                                      ?.value ??
                                  0;
                              final isActive = index == (current % 33);

                              return Transform.translate(
                                offset: Offset(
                                  radius * cos(angle),
                                  radius * sin(angle),
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: isActive ? 24.sp : 18.sp,
                                  height: isActive ? 24.sp : 18.sp,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        isActive
                                            ? Colors.amber
                                            : (_themeController.isDarkMode.value
                                                ? Colors.grey[500]
                                                : Colors.grey[300]),
                                    boxShadow:
                                        isActive
                                            ? [
                                              BoxShadow(
                                                color: Colors.amber.withOpacity(
                                                  0.6,
                                                ),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ]
                                            : [],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        SizedBox(height: 20.sp),

                   
                        Text(
                          'ژمارەی زیکرەکانم: ${_tasbihController.phraseCounters[_tasbihController.selectedPhrase.value]?.value ?? 0}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: 'ZainPeet',
                            fontWeight: FontWeight.bold,
                            color: _themeController.textAppBar,
                          ),
                        ),

                        SizedBox(height: 20.sp),

                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                _tasbihController.increment();
                              
                              },
                              icon:  Icon(Icons.add , color: _themeController.textAppBar,),
                              iconSize: 35.sp,
                            ),
                            SizedBox(width: 10.sp),
                            IconButton(
                              onPressed: () {
                                _tasbihController.reset();
                              },
                              icon:  Icon(Icons.refresh_rounded, color: _themeController.textAppBar,),
                              iconSize: 35.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
        ),
      ),
    );
  }
}
