import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/FontSizeController.dart';
import 'package:food/controller/NotificationPreferenceController.dart';
import 'package:food/view/SuggestionPage.dart';
import 'package:food/view/utils/images.dart';
import 'package:food/view/widgets/CustomBottomNavigationBar.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/ThemeController.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final String facebookUrl =
      'https://www.facebook.com/Dr.Abdul.Wahid.Official.page/';
  final String instagramUrl = 'https://www.instagram.com/dr.abdulwahid.kurdi/';
  final String youtubeUrl = 'https://www.youtube.com/c/drabdulwahid';

  Future<void> _launchFacebook() async {
    final url = 'https://www.facebook.com/Dr.Abdul.Wahid.Official.page/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      await launch(facebookUrl);
    }
  }

  Future<void> _launchInstagram() async {
    final url = 'https://www.instagram.com/dr.abdulwahid.kurdi/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      await launch(instagramUrl);
    }
  }

  Future<void> _launchYoutube() async {
    final url = 'https://www.youtube.com/c/drabdulwahid';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      await launch(youtubeUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _themeController = Get.find<ThemeController>();
    final fontSizeController = Get.put(FontSizeController());
    // final NotificationPreferenceController _notificationController = Get.find();

    return Obx(
      () => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: _themeController.scaffold,
          appBar: AppBar(
            title: Text(
              'ڕیکخستنەکان',
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'ZainPeet',
                color: _themeController.textAppBar,
              ),
            ),
            centerTitle: true,
            backgroundColor: _themeController.appBar,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// 🔹 Theme & Font Size Container
                  Container(
                    decoration: BoxDecoration(
                      color: _themeController.cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'گۆڕینی ڕەنگ',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: 'ZainPeet',
                                color: _themeController.textAppBar,
                              ),
                            ),
                            DropdownButton<String>(
                              dropdownColor: _themeController.cardColor,
                              value: _themeController.themeSource.value
                                  .toLowerCase(), // make sure value is lowercase
                              onChanged: (val) {
                                if (val != null) _themeController.setTheme(val);
                              },
                              style: TextStyle(
                                fontFamily: 'ZainPeet',
                                fontSize: 16.sp,
                                color: _themeController.textAppBar,
                              ),

                              items: [
                                DropdownMenuItem(
                                  alignment: Alignment.centerRight,
                                  value: 'system',
                                  child: Text('سیستەم'),
                                ),
                                DropdownMenuItem(
                                  alignment: Alignment.centerRight,
                                  value: 'light',
                                  child: Text('ڕووناک'),
                                ),
                                DropdownMenuItem(
                                  alignment: Alignment.centerRight,
                                  value: 'dark',
                                  child: Text('تاریک'),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Obx(() {
                        //   return SwitchListTile(
                        //     title: Text(
                        //       _themeController.isDarkMode.value
                        //           ? 'ڕەنگی تاریک چالاکە'
                        //           : 'ڕەنگی ڕووناک چالاکە',
                        //       style: TextStyle(
                        //         fontSize: 16.sp,
                        //         fontFamily: 'ZainPeet',
                        //         color: _themeController.textAppBar,
                        //       ),
                        //     ),
                        //     secondary: Icon(
                        //       _themeController.isDarkMode.value
                        //           ? Icons.dark_mode
                        //           : Icons.light_mode,
                        //       color: _themeController.textAppBar,
                        //     ),
                        //     activeColor: _themeController.iconBottonNav,
                        //     value: _themeController.isDarkMode.value,
                        //     onChanged: (val) {
                        //       _themeController.toggleTheme();
                        //     },
                        //   );
                        // }),
                        const SizedBox(height: 10),
                        Text(
                          'گۆڕینی قەبارەی نووسین',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: 'ZainPeet',
                            color: _themeController.textAppBar,
                          ),
                        ),
                        Obx(() {
                          return Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  thumbColor: Colors.blue,
                                  activeColor: _themeController.iconBottonNav,
                                  inactiveColor: _themeController.iconBottonNav,
                                  min: 15.0,
                                  max: 25.0,
                                  value:
                                      fontSizeController.kurdishFontSize.value,
                                  onChanged: (value) {
                                    fontSizeController.updateKurdishFontSize(
                                      value,
                                    );
                                  },
                                ),
                              ),
                              Text(
                                '${fontSizeController.kurdishFontSize.value.toInt()}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: _themeController.textAppBar,
                                ),
                              ),
                            ],
                          );
                        }),
                        Obx(() {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SizedBox(
                                width: 300.w,
                                height: 50.h,
                                child: Text(
                                  'بەرنامەی خۆراکی پێغەمبەر ﷺ',
                                  style: TextStyle(
                                    fontSize: fontSizeController
                                        .kurdishFontSize.value,
                                    fontFamily: 'ZainPeet',
                                    color: _themeController.textAppBar,
                                    height: 1.8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔹 Notification Container
                  Container(
                    decoration: BoxDecoration(
                      color: _themeController.cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          trailing: Icon(Icons.arrow_forward_ios),
                          leading: Image.asset(
                            facebook,
                            width: 30.sp,
                            height: 30.sp,
                          ),
                          title: Text(
                            'پەیجی فەیسبووک',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'ZainPeet',
                              color: _themeController.textAppBar,
                            ),
                          ),
                          onTap: _launchFacebook,
                        ),
                        Divider(
                          color: _themeController.textAppBar.withOpacity(0.2),
                        ),
                        ListTile(
                          trailing: Icon(Icons.arrow_forward_ios),
                          leading: Image.asset(
                            instagram,
                            width: 30.sp,
                            height: 30.sp,
                          ),
                          title: Text(
                            'پەیجی ئینستاگرام',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'ZainPeet',
                              color: _themeController.textAppBar,
                            ),
                          ),
                          onTap: _launchInstagram,
                        ),
                        Divider(
                          color: _themeController.textAppBar.withOpacity(0.2),
                        ),
                        ListTile(
                          trailing: Icon(Icons.arrow_forward_ios),
                          leading: Image.asset(
                            youtube,
                            width: 30.sp,
                            height: 30.sp,
                          ),
                          title: Text(
                            'چەناڵی یوتوب',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'ZainPeet',
                              color: _themeController.textAppBar,
                            ),
                          ),
                          onTap: _launchYoutube,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔹 About App & Share Container
                  Container(
                    decoration: BoxDecoration(
                      color: _themeController.cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.share,
                            color: _themeController.textAppBar,
                          ),
                          title: Text(
                            'بڵاوبکەرەوە',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'ZainPeet',
                              color: _themeController.textAppBar,
                            ),
                          ),
                          onTap: () {
                            Share.share(
                              'https://play.google.com/store/apps/details?id=com.fyxtech.muslim&pcampaignid=web_share',
                            );
                          },
                        ),
                        Divider(
                          color: _themeController.textAppBar.withOpacity(0.2),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.info,
                            color: _themeController.textAppBar,
                          ),
                          title: Text(
                            'دەربارەی بەرنامە',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'ZainPeet',
                              color: _themeController.textAppBar,
                            ),
                          ),
                          onTap: () {
                            Get.defaultDialog(
                              title: "دەربارە",
                              titleStyle: TextStyle(
                                fontSize: 20.sp,
                                fontFamily: 'ZainPeet',
                              ),
                              content: Column(
                                children: [
                                  Text(
                                    'بەرنامەی خۆراکی پێغەمبەر ﷺ',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: 'ZainPeet',
                                    ),
                                  ),
                                  SizedBox(height: 10.sp),
                                  Text(
                                    'وەشانی بەرنامە: 1.0.0',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: 'ZainPeet',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 3),
        ),
      ),
    );
  }
}
