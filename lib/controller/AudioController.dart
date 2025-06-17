import 'dart:convert';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:food/Model/AudioModel.dart';
import 'package:food/Model/DownloadedAudio.dart';

class AudioRawazController extends GetxController {
  final player = AudioPlayer();

  var currentPosition = Duration.zero.obs;
  var currentDuration = Duration.zero.obs;
  var isPaused = false.obs; // true if audio is paused (not playing)
  RxBool isOnlineMode = true.obs; // true = online audios, false = downloaded audios
  var isPlaying = false.obs;
  var currentAudioTitle = ''.obs;
  var topPlayButtonVisible = true.obs;
  var bottomPlayButtonVisible = false.obs;

  var audioList = <AudioModel>[].obs; // online audios list
  List<DownloadedAudio> downloadedAudios = []; // offline audios list

  // Current playlist can be AudioModel or DownloadedAudio depending on mode
  List<dynamic> currentPlaylist = [];
  int currentIndex = -1;

  RxDouble playbackSpeed = 1.0.obs;
  final String imageKitUrl = 'https://ik.imagekit.io/n4ye4m0mih/';
  final String folderName = 'Audios';
  var isDoubleSpeed = false.obs;

  @override
  void onInit() {
    super.onInit();

    player.positionStream.listen((pos) {
      currentPosition.value = pos;
      update();
    });

    player.durationStream.listen((dur) {
      if (dur != null) currentDuration.value = dur;
      update();
    });

    player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        isPlaying.value = false;
        currentPosition.value = Duration.zero;
        // Auto-play next when current finishes
        playNext();
      }
      update();
    });
  }

  Future<void> fetchAudios() async {
    try {
      final apiEndpoint =
          'https://api.imagekit.io/v1/files?folder=$folderName&sort=ASC_CREATED';

      String privateKey = 'private_Hmre0i5Mw/gCy6Tc22MKrziQj5c=';
      String encodedKey = base64Encode(utf8.encode('$privateKey:'));

      final response = await http.get(
        Uri.parse(apiEndpoint),
        headers: {'Authorization': 'Basic $encodedKey'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          audioList.clear();
          for (var file in data) {
            if (file['type'] == 'file' && file['url'] != null) {
              audioList.add(
                AudioModel(title: cleanTitle(file['name']), url: file['url']),
              );
            }
          }
          update();
        } else {
          print('Unexpected response format.');
        }
      } else {
        print('Failed to load audios: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching audios: $e');
    }
  }

  // Set downloaded audios list
  void updateDownloadedAudios(List<DownloadedAudio> list) {
    downloadedAudios = list;
  }

  // Set current playlist and mode (online/offline)
  void setCurrentPlaylist({required bool onlineMode, required List<dynamic> playlist}) {
    isOnlineMode.value = onlineMode;
    currentPlaylist = playlist;
    currentIndex = -1;
  }

  Future<void> playAudio(dynamic audio, {bool offline = false}) async {
    String title = offline ? cleanTitle(audio.title) : audio.title;

    if (currentAudioTitle.value == title) {
      if (isPlaying.value) {
        await player.pause();
        isPlaying.value = false;
      } else {
        await player.play();
        isPlaying.value = true;
      }
    } else {
      currentAudioTitle.value = title;

      if (offline) {
        await player.setFilePath(audio.filePath);
        currentPlaylist = downloadedAudios;
        currentIndex = downloadedAudios.indexWhere((a) => cleanTitle(a.title) == title);
        isOnlineMode.value = false;
      } else {
        await player.setAudioSource(AudioSource.uri(Uri.parse(audio.url)));
        currentPlaylist = audioList;
        currentIndex = audioList.indexWhere((a) => a.title == title);
        isOnlineMode.value = true;
      }

      await player.play();
      isPlaying.value = true;
    }
  }

  void seek(Duration position) {
    player.seek(position);
    currentPosition.value = position;
  }

  String cleanTitle(String rawName) {
    String nameWithoutExtension = rawName.replaceAll('.mp3', '');
    nameWithoutExtension = nameWithoutExtension.replaceAll(
      RegExp(r'MP3.*'),
      '',
    );
    String cleaned = nameWithoutExtension.replaceAll('_', ' ');

    if (cleaned.startsWith('١٦ ')) {
      cleaned = cleaned.substring(3);
    }

    return cleaned.trim();
  }

  void playNext() {
    if (isOnlineMode.value) {
      // Online mode: play next in online list
      if (audioList.isEmpty) return;

      currentIndex++;
      if (currentIndex >= audioList.length) currentIndex = 0;

      _playByIndex(currentIndex);
    } else {
      // Offline mode: play next in downloaded list
      if (downloadedAudios.isEmpty) return;

      currentIndex++;
      if (currentIndex >= downloadedAudios.length) currentIndex = 0;

      _playDownloadedByIndex(currentIndex);
    }
  }

  void playPrevious() {
    if (isOnlineMode.value) {
      // Online mode: previous in online list
      if (audioList.isEmpty) return;

      currentIndex--;
      if (currentIndex < 0) currentIndex = audioList.length - 1;

      _playByIndex(currentIndex);
    } else {
      // Offline mode: previous in downloaded list
      if (downloadedAudios.isEmpty) return;

      currentIndex--;
      if (currentIndex < 0) currentIndex = downloadedAudios.length - 1;

      _playDownloadedByIndex(currentIndex);
    }
  }

  Future<void> _playByIndex(int index) async {
    try {
      var audio = currentPlaylist[index];
      currentIndex = index;

      if (isOnlineMode.value) {
        currentAudioTitle.value = audio.title;
        await player.setAudioSource(AudioSource.uri(Uri.parse(audio.url)));
      } else {
        currentAudioTitle.value = cleanTitle(audio.title);
        await player.setFilePath(audio.filePath);
      }

      await player.play();
      isPlaying.value = true;
    } catch (e) {
      print('Error playing audio at index $index: $e');
    }
  }

  Future<void> _playDownloadedByIndex(int index) async {
    try {
      var audio = downloadedAudios[index];
      currentIndex = index;
      isOnlineMode.value = false;  // <-- Correctly set offline mode here

      currentAudioTitle.value = cleanTitle(audio.title);
      await player.setFilePath(audio.filePath);
      await player.play();
      isPlaying.value = true;
    } catch (e) {
      print('Error playing downloaded audio at index $index: $e');
    }
  }

  void setPlaybackSpeed(double speed) {
    playbackSpeed.value = speed;
    player.setSpeed(speed);
  }

  void toggleSpeed() {
    isDoubleSpeed.value = !isDoubleSpeed.value;
    player.setSpeed(isDoubleSpeed.value ? 2.0 : 1.0);
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
