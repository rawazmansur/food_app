import 'dart:convert';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:food/Model/AudioModel.dart';

class AudioRawazController extends GetxController {
  final player = AudioPlayer();

  var currentPosition = Duration.zero.obs;
  var currentDuration = Duration.zero.obs;
  var isPaused = false.obs; // true if audio is paused (not playing)

  var isPlaying = false.obs;
  var currentAudioTitle = ''.obs;
  var topPlayButtonVisible = true.obs;
  var bottomPlayButtonVisible = false.obs;

  var audioList = <AudioModel>[].obs;
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

  Future<void> playAudio(AudioModel audio) async {
    if (currentAudioTitle.value == audio.title) {
      if (isPlaying.value) {
        await player.pause();
        isPlaying.value = false;
      } else {
        await player.play();
        isPlaying.value = true;
      }
    } else {
      currentAudioTitle.value = audio.title;
      await player.setAudioSource(AudioSource.uri(Uri.parse(audio.url)));
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

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }

  void playNext() {
    int currentIndex = audioList.indexWhere(
      (a) => a.title == currentAudioTitle.value,
    );
    if (currentIndex < audioList.length - 1) {
      playAudio(audioList[currentIndex + 1]);
    }
  }

  void playPrevious() {
    int currentIndex = audioList.indexWhere(
      (a) => a.title == currentAudioTitle.value,
    );
    if (currentIndex > 0) {
      playAudio(audioList[currentIndex - 1]);
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
}
