import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'widgets/frequency_dial.dart';
import '../../shared/widgets/headphone_sheet.dart';
import '../data/radio_service.dart';
import '../domain/radio_state.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RadioScreen extends ConsumerWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(radioProvider);
    final notifier = ref.read(radioProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Now Playing",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        Text(
                          state.mode == RadioMode.hardware ? "Hardware FM" : "Online Radio",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        state.mode == RadioMode.hardware ? PhosphorIcons.radio() : PhosphorIcons.globe(),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        // Toggle between Online and Hardware
                        if (state.mode == RadioMode.online) {
                          if (!state.isHeadsetConnected) {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => HeadphoneSheet(
                                onSwitchToOnline: () => notifier.switchMode(RadioMode.online),
                              ),
                            );
                          } else {
                            notifier.switchMode(RadioMode.hardware);
                          }
                        } else {
                          notifier.switchMode(RadioMode.online);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              
              // Frequency Dial
              FrequencyDial(
                frequency: state.frequency,
                onFrequencyChanged: (freq) => notifier.setFrequency(freq),
              ),
              
              const Spacer(),
              
              // Station Info / RDS
              if (state.isPlaying)
                Column(
                  children: [
                    Text(
                      state.rdsText ?? (state.mode == RadioMode.online ? "Zeno FM Stream" : "Searching..."),
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ).animate().fadeIn(),
                    if (state.isRecording)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            8,
                            (index) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              width: 4,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ).animate(onPlay: (controller) => controller.repeat()).scaleY(
                                  begin: 0.5,
                                  end: 1.5,
                                  duration: (300 + (index * 100)).ms,
                                  curve: Curves.easeInOut,
                                ),
                          ),
                        ),
                      ),
                  ],
                ),
              
              const SizedBox(height: 40),
              
              // Main Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Rewind / Seek Down
                  _CircleButton(
                    icon: PhosphorIcons.rewind(),
                    size: 60,
                    onPressed: () {},
                  ),
                  
                  // Power Button
                  GestureDetector(
                    onTap: () => notifier.togglePower(),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state.isPlaying ? Colors.white : Theme.of(context).colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            color: (state.isPlaying ? Colors.white : Theme.of(context).colorScheme.primary).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        state.isPlaying ? PhosphorIcons.stop(PhosphorIconsStyle.fill) : PhosphorIcons.play(PhosphorIconsStyle.fill),
                        size: 40,
                        color: state.isPlaying ? Colors.black : Colors.white,
                      ),
                    ),
                  ).animate(target: state.isPlaying ? 1 : 0).shimmer(duration: 2.seconds),
                  
                  // Fast Forward / Seek Up
                  _CircleButton(
                    icon: PhosphorIcons.fastForward(),
                    size: 60,
                    onPressed: () {},
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Recording Trigger
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: InkWell(
                  onTap: () {
                    if (state.isPlaying) {
                      notifier.toggleRecording();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Start radio first to record")),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: state.isRecording ? Colors.red.withOpacity(0.2) : Colors.white10,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: state.isRecording ? Colors.red : Colors.white24,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          PhosphorIcons.circle(PhosphorIconsStyle.fill),
                          color: state.isRecording ? Colors.red : Colors.white54,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          state.isRecording ? "STOP RECORDING" : "TAP TO RECORD",
                          style: TextStyle(
                            color: state.isRecording ? Colors.red : Colors.white70,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onPressed;

  const _CircleButton({
    required this.icon,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.4),
      ),
    );
  }
}
