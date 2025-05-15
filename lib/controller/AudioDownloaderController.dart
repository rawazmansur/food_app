import 'dart:io';
import 'package:flutter/material.dart';
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
      await requestManageExternalStoragePermission();

      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        Get.snackbar(
          'کێشەیەک هەیە',
          'تکایە دواتر هەوڵبدەرەوە',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          borderRadius: 8,
          margin: EdgeInsets.all(10),
        );
        return;
      }

      final file = File('${dir.path}/$filename');

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

        Get.snackbar(
          'سەرکەوتوو بوو',
          'وتارەکەت بە سەرکەووتووی دابەزی',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
          borderRadius: 8,
          margin: EdgeInsets.all(10),
          titleText: Text(
            'سەرکەوتوو بوو',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'zainPeet',
              fontWeight: FontWeight.bold,
            ),
          ),
          messageText: Text(
            'وتارەکەت بە سەرکەووتووی دابەزی',
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.white, fontFamily: 'zainPeet'),
          ),
          duration: Duration(seconds: 3),
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
}
