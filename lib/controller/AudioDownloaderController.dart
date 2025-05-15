import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AudioDownloaderController extends GetxController {
  var isDownloading = false.obs;
  var downloadProgress = 0.0.obs;
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
        titleText: Text(
          'کێشەیەک هەیە',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'YourFontName', // Replace with your font
            fontWeight: FontWeight.bold,
          ),
        ),
        messageText: Text(
          'نەتوانرا بەرزکردنەوەی فایلی دابنێ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'YourFontName',
          ),
        ),
      );
      return;
    }

    final file = File('${dir.path}/$filename');

    final request = http.Request('GET', Uri.parse(url));
    final client = http.Client();
    final response = await client.send(request);

    if (response.statusCode == 200) {
      // Get total size for progress calculation
      final contentLength = response.contentLength ?? 0;
      List<int> bytes = [];
      int received = 0;

      // Show initial snackbar with progress widget (you may want to implement a custom widget)
      Get.snackbar(
        'دابەزاندن',
        'ئەمە بەردەوامە...',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.shade700,
        colorText: Colors.white,
        borderRadius: 8,
        margin: EdgeInsets.all(10),
        snackStyle: SnackStyle.FLOATING,
        titleText: Text(
          'دابەزاندن',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'zainpeet',
            fontWeight: FontWeight.bold,
          ),
        ),
        messageText: Obx(() {
          // You'll want to have a controller observable for progress, but 
          // here, it's just a placeholder, so we update snackbar manually.
          return Text(
            'تکایە چاودێر بکە... 0%',
            style: TextStyle(color: Colors.white, fontFamily: 'zainpeet'));
        }),
        isDismissible: false,
      );

      // Instead of Obx inside snackbar, better update progress in a GetX controller variable
      // So below is a manual way to track progress

      // Buffer the response stream
      final stream = response.stream;

      await for (var chunk in stream) {
        bytes.addAll(chunk);
        received += chunk.length;
        final double progress = contentLength != 0 ? received / contentLength : 0;

        // Update the progress snackbar message manually
        Get.closeAllSnackbars();
        Get.snackbar(
          'دابەزاندن',
          'پڕۆسە بەردەوامە...',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue.shade700,
          colorText: Colors.white,
          borderRadius: 8,
          margin: EdgeInsets.all(10),
          snackStyle: SnackStyle.FLOATING,
          titleText: Text(
            'دابەزاندن',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'zainPeet',
              fontWeight: FontWeight.bold,
            ),
          ),
          messageText: LinearPercentIndicator(
            lineHeight: 14.0,
            percent: progress,
            backgroundColor: Colors.grey.shade300,
            progressColor: Colors.greenAccent,
            center: Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'zainPeet',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          isDismissible: false,
        );
      }

      // Write all bytes to file
      await file.writeAsBytes(bytes);

      // Close progress snackbar and show success
      Get.closeAllSnackbars();
      Get.snackbar(
        'سەرکەوتوو بوو',
        'ووتار بەسەرکەوتویی دابەزاند',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
        borderRadius: 8,
        margin: EdgeInsets.all(10),
        titleText: Text(
          'سەرکەوتوو بوو',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'zainPeet',
            fontWeight: FontWeight.bold,
          ),
        ),
        messageText: Text(
          'ووتار بەسەرکەوتویی دابەزاند',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'zainPeet',
          ),
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
        titleText: Text(
          'کێشەیەک هەیە',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'zainPeet',
            fontWeight: FontWeight.bold,
          ),
        ),
        messageText: Text(
          'نەتوانرا ووتار دابەزێنرێت',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'zainPeet',
          ),
        ),
      );
    }
  } catch (e) {
    Get.snackbar(
      'کێشەیەک هەیە',
      e.toString(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      borderRadius: 8,
      margin: EdgeInsets.all(10),
      titleText: Text(
        'کێشەیەک هەیە',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'zainPeet',
          fontWeight: FontWeight.bold,
        ),
      ),
      messageText: Text(
        e.toString(),
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'zainPeet',
        ),
      ),
    );
  }
}
}
