import 'dart:io';
import 'package:food/Model/DownloadedAudio.dart';

class DownloadManager {
  static Future<List<DownloadedAudio>> getDownloadedAudios() async {
    final downloadsDir = Directory('/storage/emulated/0/Download');
    if (!await downloadsDir.exists()) return [];

    final files = downloadsDir.listSync();

    final myAudioFiles = files.where((file) {
      final name = file.path.split('/').last;
      return file is File &&
          name.endsWith('.mp3') &&
          name.startsWith('foodapp_');
    });

    return myAudioFiles.map((file) {
      final name = file.path.split('/').last.replaceFirst('foodapp_', '');
      return DownloadedAudio(title: name, filePath: file.path);
    }).toList();
  }
}
