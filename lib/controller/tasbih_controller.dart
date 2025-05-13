import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbihController extends GetxController {
  // List of phrases
  final List<String> phrases = [
    "سبحان الله",
    "الحمد لله",
    "الله أكبر",
    "لا إله إلا الله",
    "استغفر الله"
  ];

  // Initialize a strongly-typed RxMap for phrase counters
  RxMap<String, RxInt> phraseCounters = <String, RxInt>{}.obs;

  // The selected phrase from the dropdown
  var selectedPhrase = 'سبحان الله'.obs;

  // Initialize counters for each phrase
  void initializeCounters() async {
    final prefs = await SharedPreferences.getInstance();
    for (var phrase in phrases) {
      // Load the saved counter for each phrase, or set it to 0 if not found
      int counterValue = prefs.getInt(phrase) ?? 0;
      phraseCounters[phrase] = RxInt(counterValue);
    }
  }

  // Increment the counter for the selected phrase
  void increment() async {
    final prefs = await SharedPreferences.getInstance();
    int newValue = phraseCounters[selectedPhrase.value]!.value + 1;
    phraseCounters[selectedPhrase.value]?.value = newValue;

    // Save the updated counter in SharedPreferences
    prefs.setInt(selectedPhrase.value, newValue);
  }

  // Reset the counter for the selected phrase
  void reset() async {
    final prefs = await SharedPreferences.getInstance();
    phraseCounters[selectedPhrase.value]?.value = 0;

    // Reset the counter in SharedPreferences
    prefs.setInt(selectedPhrase.value, 0);
  }

  @override
  void onInit() {
    super.onInit();
    initializeCounters(); // Initialize counters when the controller is created
  }
}
