import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/AudioController.dart';
import 'package:food/controller/AudioDownloaderController.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart'; // assuming you're using just_audio for audio playback

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
              return Center(child: CircularProgressIndicator());
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
                    margin: EdgeInsets.only(bottom: 20.h),
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 16.w,
                    ),
                    decoration: BoxDecoration(
                      color:
                          themeController.scaffold == Colors.white
                              ? Colors.grey.shade200
                              : Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                audio.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontFamily: 'ZainPeet',
                                  color: themeController.textAppBar,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              color: themeController.scaffold,
                              icon: Icon(
                                Icons.more_vert,
                                color: themeController.textAppBar,
                              ),
                              onSelected: (value) {
                                if (value == 'download') {
                                  audioDownloaderController.downloadAudio(
                                    audio.url,
                                    '${audio.title}.mp3',
                                  );
                                }
                              },
                              itemBuilder:
                                  (BuildContext context) => [
                                    PopupMenuItem(
                                      
                                      
                                      value: 'download',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.download,
                                            color: themeController.textAppBar,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            'داگرتن' , 
                                            style: TextStyle(
                                                 fontSize: 16.sp,
                                        color: themeController.textAppBar,
                                        fontFamily: 'ZainPeet',
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),

                        // Play/Pause button centered
                        IconButton(
                          iconSize: 60.sp,
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            audioController.playAudio(audio);
                          },
                        ),

                        // Show slider & duration only for currently playing audio
                        if (audioController.currentAudioTitle.value ==
                            audio.title) ...[
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
                            activeColor: Colors.blue,
                            inactiveColor: Colors.grey,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatDuration(position),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: themeController.textAppBar,
                                  ),
                                ),
                                Text(
                                  formatDuration(duration),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: themeController.textAppBar,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
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
