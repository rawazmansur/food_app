import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/AudioController.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerPage extends StatefulWidget {
  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  // Access the controller
  final AudioRawazController audioController = Get.find();
  ThemeController themeController = Get.find();
  @override
  void initState() {
    super.initState();
    // Fetch the audio files when the page loads
    audioController.fetchAudios();
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
            controller.audioList.sort((a, b) => a.title.compareTo(b.title));
            return Column(
              children: [
                // List of audios to choose from
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.audioList.length,
                    itemBuilder: (context, index) {
                      final audio = controller.audioList[index];
                      return ListTile(
                        title: Text(
                          audio.title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'ZainPeet',
                            color: themeController.textAppBar,
                          ),
                        ),
                        onTap: () {
                          controller.playAudio(audio);
                        },
                        trailing: IconButton(
                          icon: Icon(
                            controller.isPlaying.value &&
                                    controller.currentAudioTitle.value ==
                                        audio.title
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          onPressed: () {
                            if (controller.isPlaying.value &&
                                controller.currentAudioTitle.value ==
                                    audio.title) {
                              controller
                                  .stopAudio(); // Stop if currently playing
                            } else {
                              controller.playAudio(audio); // Play if stopped
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
