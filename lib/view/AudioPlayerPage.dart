import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/AudioController.dart';
import 'package:food/controller/AudioDownloaderController.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AudioPlayerPage extends StatefulWidget {
  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  final AudioRawazController audioController = Get.find();
  final AudioDownloaderController audioDownloaderController = Get.find();
  ThemeController themeController = Get.find();

  @override
  void initState() {
    super.initState();
    audioController.fetchAudios();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: themeController.scaffold,
        appBar: AppBar(
          backgroundColor: themeController.scaffold,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: themeController.textAppBar),
            onPressed: () => Get.back(),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  'کۆی وتارە دەنگیەکان',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'ZainPeet',
                    color: themeController.textAppBar,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: GetBuilder<AudioRawazController>(
          builder: (controller) {
            if (controller.audioList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'پێویستت بە ئینتەرنێت هەیە بۆ\n گوێگرتن لە وتارە دەنگیەکان',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontFamily: 'ZainPeet',
                        color: themeController.textAppBar,
                      ),
                    ),
                    SizedBox(height: 25.h),
                    CircularProgressIndicator(
                      color: themeController.textAppBar,
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: ListView.builder(
                itemCount: audioController.audioList.length,
                itemBuilder: (context, index) {
                  final audio = audioController.audioList[index];
                  final isPlaying =
                      audioController.isPlaying.value &&
                      audioController.currentAudioTitle.value == audio.title;
                  final position = audioController.currentPosition.value;
                  final duration = audioController.currentDuration.value;

                  return Container(
                    margin: EdgeInsets.only(bottom: 24.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            themeController.isDarkMode.value
                                ? [
                                  Color.fromARGB(
                                    255,
                                    36,
                                    36,
                                    36,
                                  ), // your storyContainer dark shade
                                  Color.fromARGB(
                                    255,
                                    41,
                                    41,
                                    41,
                                  ), // your cardColor dark shade
                                  Color(
                                    0xFF2A2A2A,
                                  ), // slightly darker gray for depth
                                ]
                                : [Color(0xFFFDFCFB), Color(0xFFE2D1C3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            children: [
                              // 🎵 Album Art
                              Container(
                                height: 180.h,
                                width: 180.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 12,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      'https://upload.wikimedia.org/wikipedia/commons/f/fc/Dr_Abdulwahid.jpg',
                                    ),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.5),
                                      BlendMode.darken,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // 🎤 Title
                              Text(
                                audio.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontFamily: 'ZainPeet',
                                  fontWeight: FontWeight.w700,
                                  color: themeController.textAppBar,
                                ),
                              ),

                              SizedBox(height: 16.h),

                              SizedBox(height: 8.h),

                              // 🔽 Play/Pause Button + Conditional Controls
                              Obx(() {
                                final isCurrent =
                                    audioController.currentAudioTitle.value ==
                                    audio.title;
                                final isPlaying =
                                    audioController.isPlaying.value &&
                                    isCurrent;

                                if (isPlaying) {
                                  // 🟢 Show full controls for currently playing audio
                                  return Column(
                                    children: [
                                      Slider(
                                        min: 0,
                                        max: duration.inSeconds.toDouble(),
                                        value:
                                            position.inSeconds
                                                .clamp(0, duration.inSeconds)
                                                .toDouble(),
                                        onChanged: (value) {
                                          audioController.seek(
                                            Duration(seconds: value.toInt()),
                                          );
                                        },
                                        activeColor:
                                            themeController.iconBottonNav,
                                        inactiveColor: Colors.grey,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              formatDuration(position),
                                              style: TextStyle(
                                                color:
                                                    themeController.textAppBar,
                                              ),
                                            ),
                                            Text(
                                              formatDuration(duration),
                                              style: TextStyle(
                                                color:
                                                    themeController.textAppBar,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.skip_previous_rounded,
                                            ),
                                            iconSize: 40.sp,
                                            color:
                                                themeController.iconBottonNav,
                                            onPressed:
                                                () =>
                                                    audioController
                                                        .playPrevious(),
                                          ),
                                          SizedBox(width: 20.w),
                                          IconButton(
                                            icon: Icon(
                                              Icons.pause_circle_filled,
                                            ),
                                            iconSize: 40.sp,
                                            color:
                                                themeController.iconBottonNav,
                                            onPressed: () {
                                              audioController.player.pause();
                                              audioController.isPlaying.value =
                                                  false;
                                            },
                                          ),
                                          SizedBox(width: 20.w),
                                          IconButton(
                                            icon: Icon(Icons.skip_next_rounded),
                                            iconSize: 40.sp,
                                            color:
                                                themeController.iconBottonNav,
                                            onPressed:
                                                () =>
                                                    audioController.playNext(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                } else {
                                  // 🔵 Show Play button always when not playing
                                  return IconButton(
                                    icon: Icon(Icons.play_circle_filled),
                                    iconSize: 50.sp,
                                    color: themeController.iconBottonNav,

                                    onPressed: () async {
                                      final connectivityResult =
                                          await Connectivity()
                                              .checkConnectivity();
                                      final hasInternet =
                                          connectivityResult !=
                                          ConnectivityResult.none;

                                      if (!hasInternet) {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.error,
                                          title: 'ئینتەرنێتت نیە',
                                          text:
                                              'ببورە، ناتوانیت دەنگەکە پەخش بکەیت چونکە تۆ ئینتەرنێت نیە.',
                                          confirmBtnText: 'باشە',
                                          confirmBtnColor:
                                              themeController.iconBottonNav,
                                          onConfirmBtnTap: () {
                                            Get.back();
                                          },
                                        );
                                      } else {
                                        audioController.playAudio(audio);
                                      }
                                    },
                                  );
                                }
                              }),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // 🔁 x1/x2 Speed Button
                                  Obx(() {
                                    final isCurrent =
                                        audioController
                                            .currentAudioTitle
                                            .value ==
                                        audio.title;
                                    if (!isCurrent)
                                      return SizedBox(); // Only show for current playing audio

                                    return TextButton(
                                      onPressed: () {
                                        audioController.toggleSpeed();
                                      },
                                      child: Text(
                                        audioController.isDoubleSpeed.value
                                            ? '2x '
                                            : '1x',
                                        style: TextStyle(
                                          color: themeController.textAppBar,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }),
                                  // ⬇️ Download
                                  IconButton(
                                    iconSize: 25.sp,
                                    icon: Icon(
                                      Icons.download,
                                      color: themeController.textAppBar,
                                    ),
                                    onPressed: () {
                                      audioDownloaderController.downloadAudio(
                                        audio.url,
                                        '${audio.title}.mp3',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
