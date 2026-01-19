import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/radio_state.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

final radioProvider = StateNotifierProvider<RadioNotifier, RadioState>((ref) {
  return RadioNotifier();
});

class RadioNotifier extends StateNotifier<RadioState> {
  final AudioPlayer _player = AudioPlayer();
  final AudioRecorder _recorder = AudioRecorder();
  Timer? _recordingTimer;

  RadioNotifier() : super(RadioState()) {
    _init();
  }

  Future<void> _init() async {
    // Check for headset connectivity (mocked for now)
    // In a real app, use a plugin like 'headset_connection_event'
    state = state.copyWith(isHeadsetConnected: false);
    
    // Auto switch to online if no headset
    if (!state.isHeadsetConnected) {
      state = state.copyWith(mode: RadioMode.online);
    }
  }

  void setFrequency(double freq) {
    state = state.copyWith(frequency: freq);
    if (state.isPlaying && state.mode == RadioMode.hardware) {
      // Update hardware tuner
    }
  }

  void togglePower() async {
    if (state.isPlaying) {
      await _player.stop();
      state = state.copyWith(isPlaying: false);
    } else {
      if (state.mode == RadioMode.online) {
        // Play online stream
        try {
          await _player.setUrl("https://stream.zeno.fm/f97728shv98uv"); // Example
          await _player.play();
          state = state.copyWith(isPlaying: true);
        } catch (e) {
          print("Error playing stream: $e");
        }
      } else {
        // Power ON FM chip via MethodChannel
        state = state.copyWith(isPlaying: true);
      }
    }
  }

  void toggleRecording() async {
    if (state.isRecording) {
      final path = await _recorder.stop();
      _recordingTimer?.cancel();
      state = state.copyWith(isRecording: false, recordingDuration: Duration.zero);
      print("Recording saved to: $path");
    } else {
      if (await _recorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = "FM_${state.frequency.toStringAsFixed(1)}_$timestamp.m4a";
        final path = "${directory.path}/$fileName";

        await _recorder.start(const RecordConfig(), path: path);
        state = state.copyWith(isRecording: true);
        
        _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          state = state.copyWith(recordingDuration: Duration(seconds: timer.tick));
        });
      }
    }
  }

  void switchMode(RadioMode mode) {
    if (mode == RadioMode.hardware && !state.isHeadsetConnected) {
      // Should show warning in UI
      return;
    }
    state = state.copyWith(mode: mode);
  }

  @override
  void dispose() {
    _player.dispose();
    _recorder.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }
}
