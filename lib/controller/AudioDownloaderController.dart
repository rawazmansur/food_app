import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/controller/ThemeController.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// Import your ThemeController

class AudioDownloaderController extends GetxController {
  var isDownloading = false.obs;
  var downloadProgress = 0.0.obs;

  final themeController = Get.find<ThemeController>();

  Future<bool> requestManageExternalStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        status = await Permission.manageExternalStorage.request();
      }
      return status.isGranted;
    }
    return true; // iOS or others
  }

  Future<void> downloadAudio(String url, String filename) async {
    try {
      bool permissionGranted = await requestManageExternalStoragePermission();

      if (!permissionGranted) {
        // Permission denied: don't start download, maybe show an error message
        Get.snackbar(
            '! ئاگاداری',
            'تکایە مۆڵەتی دابەزاندنی فایلەکان بدەن',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.shade700,
          colorText: Colors.white,
          titleText: Text(
            '! ئاگاداری',
            style: TextStyle(
              fontFamily: 'zainPeet',
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: Colors.white,
              
            ),
            textAlign: TextAlign.right,
          ),
          messageText: Text(
            'تکایە مۆڵەتی دابەزاندنی فایلەکان بدەن',
            style: TextStyle(
              fontFamily: 'zainPeet',
              fontSize: 16.sp,
              color: Colors.white,
            ),
            textAlign: TextAlign.right,
          ),
          borderRadius: 8,
          margin: EdgeInsets.all(10),
        );
        return; // Stop execution here
      }

      final downloadsDir = Directory('/storage/emulated/0/Download/');

      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      final file = File('${downloadsDir.path}/foodapp_$filename');

      final request = http.Request('GET', Uri.parse(url));
      final client = http.Client();
      final response = await client.send(request);

      if (response.statusCode == 200) {
        final contentLength = response.contentLength ?? 0;
        List<int> bytes = [];
        int received = 0;

        isDownloading.value = true;
        downloadProgress.value = 0;

        // Show snackbar once with progress indicator widget
        Get.snackbar(
          'دابەزاندن',
          '',
          snackPosition: SnackPosition.TOP,
          backgroundColor:
              themeController.isDarkMode.value
                  ? const Color.fromARGB(255, 116, 166, 252)
                  : const Color.fromARGB(255, 116, 166, 252),
          colorText: Colors.white,
          borderRadius: 8,
          margin: EdgeInsets.all(10),
          snackStyle: SnackStyle.FLOATING,
          isDismissible: false,
          duration: const Duration(days: 1), // basically indefinite
          titleText: Text(
            'دابەزاندن',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'zainPeet',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
          messageText: Obx(() {
            return LinearPercentIndicator(
              lineHeight: 14.0,
              percent: downloadProgress.value,
              backgroundColor:
                  themeController.isDarkMode.value
                      ? Colors.grey.shade300
                      : Colors.grey.shade300,
              progressColor:
                  themeController.isDarkMode.value
                      ? Colors.lightGreenAccent.shade400
                      : Colors.greenAccent,
              center: Text(
                '${(downloadProgress.value * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'zainPeet',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        );

        final stream = response.stream;

        await for (var chunk in stream) {
          bytes.addAll(chunk);
          received += chunk.length;
          downloadProgress.value =
              contentLength != 0 ? received / contentLength : 0;
        }

        await file.writeAsBytes(bytes);

        isDownloading.value = false;
        Get.closeAllSnackbars();

        Get.defaultDialog(
          backgroundColor: Colors.white,
          title: '',
          titleStyle: TextStyle(fontSize: 0),
          titlePadding: EdgeInsets.zero, // Remove space reserved for title
          contentPadding:
              EdgeInsets.zero, // Remove extra padding around content

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Green header with check icon
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Icon(Icons.check, color: Colors.white, size: 50),
              ),
              SizedBox(height: 20),

              // Title
              Text(
                '! سەرکەتوو بوو',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black87,
                  fontFamily: 'zainPeet',
                ),
              ),
              SizedBox(height: 10),

              // Message
              Text(
                'بەسەرکەووتی وتارەکە داونلۆد بوو',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontFamily: 'zainPeet',
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30),

              // Okay button
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'باشە',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'zainPeet',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        Get.snackbar(
          'کێشەیەک هەیە',
          'نەتوانرا ووتار دابەزێنرێت',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          borderRadius: 8,
          margin: EdgeInsets.all(10),
        );
      }
    } catch (e) {
      isDownloading.value = false;
      Get.closeAllSnackbars();
      Get.snackbar(
        'کێشەیەک هەیە',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        borderRadius: 8,
        margin: EdgeInsets.all(10),
      );
    }
  }

  Future<List<FileSystemEntity>> getMyDownloadedMP3s() async {
    final downloadsDir = Directory('/storage/emulated/0/Download');

    if (!await downloadsDir.exists()) {
      return [];
    }

    final files = downloadsDir.listSync();

    // Filter only .mp3 files that start with "foodapp_"
    final myFiles =
        files.where((file) {
          final fileName = file.path.split('/').last;
          return file is File &&
              fileName.endsWith('.mp3') &&
              fileName.startsWith('foodapp_');
        }).toList();

    return myFiles;
  }
}
