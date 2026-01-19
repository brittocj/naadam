import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RadioMode { hardware, online }

class RadioState {
  final double frequency;
  final bool isPlaying;
  final bool isRecording;
  final RadioMode mode;
  final String? currentStation;
  final String? rdsText;
  final Duration recordingDuration;
  final bool isHeadsetConnected;

  RadioState({
    this.frequency = 98.3,
    this.isPlaying = false,
    this.isRecording = false,
    this.mode = RadioMode.online,
    this.currentStation,
    this.rdsText,
    this.recordingDuration = Duration.zero,
    this.isHeadsetConnected = false,
  });

  RadioState copyWith({
    double? frequency,
    bool? isPlaying,
    bool? isRecording,
    RadioMode? mode,
    String? currentStation,
    String? rdsText,
    Duration? recordingDuration,
    bool? isHeadsetConnected,
  }) {
    return RadioState(
      frequency: frequency ?? this.frequency,
      isPlaying: isPlaying ?? this.isPlaying,
      isRecording: isRecording ?? this.isRecording,
      mode: mode ?? this.mode,
      currentStation: currentStation ?? this.currentStation,
      rdsText: rdsText ?? this.rdsText,
      recordingDuration: recordingDuration ?? this.recordingDuration,
      isHeadsetConnected: isHeadsetConnected ?? this.isHeadsetConnected,
    );
  }
}
