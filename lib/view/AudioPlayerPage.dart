import 'dart:ui'; // Import for ImageFilter.blur

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/AudioController.dart';
import 'package:food/controller/AudioDownloaderController.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:food/view/DownloadsPage.dart';
import 'package:food/view/widgets/CustomBottomNavigationBar.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AudioPlayerPage extends StatefulWidget {
  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late final AudioRawazController audioController;
  late final AudioDownloaderController audioDownloaderController;
  late final ThemeController themeController;

  @override
  void initState() {
    super.initState();
    audioController = Get.find<AudioRawazController>();
    audioDownloaderController = Get.find<AudioDownloaderController>();
    themeController = Get.find<ThemeController>();
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
          backgroundColor: themeController.appBar,
          leading: IconButton(
            icon: Icon(
              Icons.download,
              color: themeController.textAppBar,
            ),
            onPressed: () => Get.to(() => DownloadsPage()),
          ),
          title: Text(
            'کۆی وتارە دەنگیەکان',
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: 'ZainPeet',
              color: themeController.textAppBar,
            ),
          ),
          centerTitle: true,
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
            return ListView.builder(
              key: const PageStorageKey<String>('audioPlayerPageListView'),
              itemCount: controller.audioList.length,
              padding: EdgeInsets.all(16.w),
              itemBuilder: (context, index) {
                final audio = controller.audioList[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 24.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: themeController.isDarkMode.value
                          ? const [
                              Color.fromARGB(255, 36, 36, 36),
                              Color.fromARGB(255, 41, 41, 41),
                              Color(0xFF2A2A2A),
                            ]
                          : const [
                              Color(0xFFF9FCFF), // Ultra light, almost transparent cool white
                              Color(0xFFE6F3FB), // A very gentle, ethereal light blue
                              Color(0xFFDCEAF6), // Slightly more pronounced, soft cool gray-blue
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    // Removed BoxShadow for cleaner look with BackdropFilter as discussed previously
                    // If you want a shadow, you can re-add it here.
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
                                image: DecorationImage(
                                  image: const CachedNetworkImageProvider(
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

                            // 🔽 Play/Pause Button + Conditional Controls (Refactored to GetBuilder)
                            GetBuilder<AudioRawazController>(
                              // Use a unique ID for this specific audio item's controls
                              id: 'audioControls_${audio.title}',
                              builder: (audioController) {
                                final isCurrent = audioController.currentAudioTitle.value == audio.title;
                                final isPlaying = audioController.isPlaying.value && isCurrent;

                                // IMPORTANT: For GetBuilder to react to changes here,
                                // ensure `audioController.update(['audioControls_${audio.title}'])`
                                // or `audioController.update()` is called in your controller
                                // when `isPlaying.value` or `currentAudioTitle.value` changes.

                                if (isPlaying) {
                                  // 🟢 Show full controls for currently playing audio
                                  return Column(
                                    children: [
                                      GetBuilder<AudioRawazController>(
                                        id: 'audioPosition_${audio.title}', // Granular update for slider
                                        builder: (audioController) {
                                          final position = audioController.currentPosition.value;
                                          final duration = audioController.currentDuration.value;
                                          // IMPORTANT: Call `audioController.update(['audioPosition_${audio.title}'])`
                                          // in your controller when `currentPosition.value` or `currentDuration.value` changes.
                                          return Slider(
                                            min: 0,
                                            max: duration.inSeconds.toDouble(),
                                            value: position.inSeconds
                                                .clamp(0, duration.inSeconds)
                                                .toDouble(),
                                            onChanged: (value) {
                                              audioController.seek(
                                                  Duration(seconds: value.toInt()));
                                              // Calling seek should ideally trigger an update in the controller itself.
                                            },
                                            activeColor: themeController.iconBottonNav,
                                            inactiveColor: Colors.grey,
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                                        child: GetBuilder<AudioRawazController>(
                                          id: 'audioTime_${audio.title}', // Granular update for time texts
                                          builder: (audioController) {
                                            final position = audioController.currentPosition.value;
                                            final duration = audioController.currentDuration.value;
                                            // IMPORTANT: Call `audioController.update(['audioTime_${audio.title}'])`
                                            // in your controller when `currentPosition.value` or `currentDuration.value` changes.
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  formatDuration(position),
                                                  style: TextStyle(
                                                    color: themeController.textAppBar,
                                                  ),
                                                ),
                                                Text(
                                                  formatDuration(duration),
                                                  style: TextStyle(
                                                    color: themeController.textAppBar,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.skip_next_rounded),
                                            iconSize: 40.sp,
                                            color: themeController.iconBottonNav,
                                            onPressed: () => audioController.playNext(),
                                          ),
                                          SizedBox(width: 20.w),
                                          IconButton(
                                            icon: const Icon(Icons.pause_circle_filled),
                                            iconSize: 40.sp,
                                            color: themeController.iconBottonNav,
                                            onPressed: () {
                                              audioController.player.pause();
                                              audioController.isPlaying.value = false;
                                              // Manually trigger update for these controls after pausing
                                              audioController.update(['audioControls_${audio.title}']);
                                            },
                                          ),
                                          SizedBox(width: 20.w),
                                          IconButton(
                                            icon: const Icon(Icons.skip_previous_rounded),
                                            iconSize: 40.sp,
                                            color: themeController.iconBottonNav,
                                            onPressed: () => audioController.playPrevious(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                } else {
                                  // 🔵 Show Play button always when not playing
                                  return IconButton(
                                    icon: const Icon(Icons.play_circle_filled),
                                    iconSize: 50.sp,
                                    color: themeController.iconBottonNav,
                                    onPressed: () async {
                                      final connectivityResult =
                                          await Connectivity().checkConnectivity();
                                      final hasInternet = connectivityResult != ConnectivityResult.none;

                                      if (!hasInternet) {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.error,
                                          title: 'ئینتەرنێتت نیە',
                                          text: 'ببورە، ناتوانیت دەنگەکە پەخش بکەیت چونکە تۆ ئینتەرنێت نیە.',
                                          confirmBtnText: 'باشە',
                                          confirmBtnColor: themeController.iconBottonNav,
                                          onConfirmBtnTap: () {
                                            Get.back();
                                          },
                                        );
                                      } else {
                                        audioController.playAudio(audio);
                                        // Ensure audioController.playAudio() calls update() in the controller
                                        // e.g., after setting isPlaying.value = true and currentAudioTitle.value = audio.title,
                                        // it should call `update(['audioControls_${audio.title}'])` or `update()`.
                                      }
                                    },
                                  );
                                }
                              },
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // 🔁 x1/x2 Speed Button (Refactored to GetBuilder)
                                GetBuilder<AudioRawazController>(
                                  id: 'audioSpeed_${audio.title}', // Granular update for speed button
                                  builder: (audioController) {
                                    final isCurrent = audioController.currentAudioTitle.value == audio.title;
                                    if (!isCurrent) {
                                      return SizedBox(
                                          width: 60
                                              .w); // Approximate width of the button
                                    }

                                    // IMPORTANT: Call `audioController.update(['audioSpeed_${audio.title}'])`
                                    // in your controller when `isDoubleSpeed.value` changes.
                                    return TextButton(
                                      onPressed: () {
                                        audioController.toggleSpeed();
                                        // Ensure audioController.toggleSpeed() calls update() in the controller
                                        // e.g., after setting isDoubleSpeed.value, it should call `update(['audioSpeed_${audio.title}'])`.
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
                                  },
                                ),
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
            );
          },
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
      ),
    );
  }
}