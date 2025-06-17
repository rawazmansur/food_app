import 'package:flutter/material.dart';
import 'package:food/Model/DownloadedAudio.dart';
import 'package:food/controller/AudioController.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:food/database/DownloadManager.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DownloadsPage extends StatelessWidget {
  final RxList<DownloadedAudio> audios = <DownloadedAudio>[].obs;
  final AudioRawazController controller = Get.find();
  final ThemeController themeController = Get.find();

  DownloadsPage({super.key}) {
    loadDownloads();
  }

  void loadDownloads() async {
    final list = await DownloadManager.getDownloadedAudios();
    audios.assignAll(list);
    controller.updateDownloadedAudios(list); // Update controller's downloaded list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.scaffold,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: themeController.textAppBar),
          onPressed: () => Get.back(),
        ),
        backgroundColor: themeController.appBar,
        centerTitle: true,
        title: Text(
          "دابەزێندراوەکان",
          style: TextStyle(
            fontFamily: 'ZainPeet',
            fontSize: 20.sp,
            color: themeController.textAppBar,
          ),
        ),
      ),
      body: Obx(() {
        if (audios.isEmpty) {
          return  Center(
            child: Text(
              "هیچ دابەزاندنێک نەکراوە",
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: 'ZainPeet', fontSize: 16.sp, color: themeController.textAppBar),
            ),
          );
        }

        return GetBuilder<AudioRawazController>(
          builder: (_) {
            return ListView.builder(
              itemCount: audios.length,
              itemBuilder: (context, index) {
                final item = audios[index];
                final isCurrent = controller.currentAudioTitle.value ==
                    controller.cleanTitle(item.title);
                final isPlaying = controller.isPlaying.value && isCurrent;

                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    controller.cleanTitle(item.title),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'ZainPeet',
                      color: themeController.textAppBar,
                    ),
                  ),
                  leading: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                      size: 32,
                      color: themeController.textAppBar,
                    ),
                    onPressed: () async {
                      if (isCurrent && controller.isPlaying.value) {
                        await controller.player.pause();
                        controller.isPlaying.value = false;
                      } else {
                        await controller.playAudio(item, offline: true);
                      }
                    },
                  ),
                  onTap: () async {
                    await controller.playAudio(item, offline: true);
                  },
                );
              },
            );
          },
        );
      }),
      bottomNavigationBar: GetBuilder<AudioRawazController>(
        builder: (_) {
          if (controller.currentAudioTitle.value.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.currentAudioTitle.value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    fontFamily: 'ZainPeet',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Slider(
                  min: 0,
                  max: controller.currentDuration.value.inMilliseconds
                      .toDouble()
                      .clamp(1, double.infinity),
                  value: controller.currentPosition.value.inMilliseconds
                      .toDouble()
                      .clamp(
                        0,
                        controller.currentDuration.value.inMilliseconds
                            .toDouble()
                            .clamp(1, double.infinity),
                      ),
                  onChanged: (value) {
                    controller.seek(Duration(milliseconds: value.toInt()));
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(controller.currentPosition.value)),
                    Text(_formatDuration(controller.currentDuration.value)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: controller.playPrevious,
                    ),
                    IconButton(
                      icon: Icon(
                        controller.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 30,
                      ),
                      onPressed: () {
                        if (controller.isPlaying.value) {
                          controller.player.pause();
                          controller.isPlaying.value = false;
                        } else {
                          controller.player.play();
                          controller.isPlaying.value = true;
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: controller.playNext,
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.speed),
                      label: Text(
                        controller.isDoubleSpeed.value ? '2x' : '1x',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      onPressed: controller.toggleSpeed,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
