import 'dart:convert';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:food/Model/AudioModel.dart'; // Ensure this model exists

class AudioRawazController extends GetxController {
  final player = AudioPlayer();
  var isPlaying = false.obs;
  var currentAudioTitle = ''.obs;

  // List to hold dynamically fetched audio URLs
  List<AudioModel> audioList = [];

  final String imageKitUrl =
      'https://ik.imagekit.io/n4ye4m0mih/'; // ImageKit base URL
  final String folderName =
      'Audios'; // Folder name where audio files are stored in ImageKit

  // Fetch audio files from ImageKit using the API (List Files)
  Future<void> fetchAudios() async {
    try {
      print('Fetching audios from ImageKit... $imageKitUrl$folderName/');

      // API endpoint for fetching files
      final apiEndpoint = 'https://api.imagekit.io/v1/files?folder=Audios';

      // Your private API key (replace with your actual private API key)
      String privateKey = 'private_Hmre0i5Mw/gCy6Tc22MKrziQj5c=';

      // Base64 encode the private key
      String encodedKey = base64Encode(utf8.encode('$privateKey:'));

      // Make the request to the API
      final response = await http.get(
        Uri.parse(apiEndpoint),
        headers: {
          'Authorization': 'Basic $encodedKey', // Use the Base64 encoded key
        },
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Print the response body to inspect its format
        print('Response body: ${response.body}');

        // Parse the response and extract filenames and URLs
        final data = jsonDecode(response.body);

        // Check the structure of the response
        if (data is List) {
          // If the response is a List, we can iterate through the list
          for (var file in data) {
            if (file['type'] == 'file' && file['url'] != null) {
              final fileName = file['name'];
              final fileUrl = file['url'];

              // Add the audio file to the list
              audioList.add(
                AudioModel(title: cleanTitle(fileName), url: fileUrl),
              );
            }
          }
       
          // Update the UI with the fetched audios
          update();
        } else {
          print('Unexpected response format. Expected a list.');
        }
      } else {
        print('Failed to load audios: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching audios: $e');
    }
  }

  // Play the audio from the URL
  Future<void> playAudio(AudioModel audio) async {
    await player.setUrl(audio.url);
    player.play();
    currentAudioTitle.value = audio.title;
    isPlaying.value = true;
  }

  // Stop the audio
  void stopAudio() {
    player.stop();
    isPlaying.value = false;
    currentAudioTitle.value = '';
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }

  String cleanTitle(String rawName) {
    // Remove the file extension
    String nameWithoutExtension = rawName.replaceAll('.mp3', '');

    // Remove 'MP3' and bitrate information
    nameWithoutExtension = nameWithoutExtension.replaceAll(
      RegExp(r'MP3.*'),
      '',
    );

    // Replace underscores with spaces
    String cleaned = nameWithoutExtension.replaceAll('_', ' ');

    // Remove the fixed "١٦" prefix if present
    if (cleaned.startsWith('١٦ ')) {
      cleaned = cleaned.substring(3); // Removes "١٦ " (3 characters)
    }

    return cleaned.trim();
  }

int extractSortNumber(String fileName) {
  // Remove the file extension
  String nameWithoutExtension = fileName.replaceAll('.mp3', '');

  // Split the name by underscores
  List<String> parts = nameWithoutExtension.split('_');

  // Ensure there are at least two parts to extract the second number
  if (parts.length >= 2) {
    // Convert Arabic numerals to Western numerals if necessary
    String arabicNumber = parts[1];
    String westernNumber = arabicNumber
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9');

    return int.tryParse(westernNumber) ?? 0;
  }

  return 0;
}
}
