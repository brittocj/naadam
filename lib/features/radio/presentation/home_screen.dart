import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'radio_screen.dart';
import '../../recordings/presentation/recordings_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../domain/radio_state.dart';
import '../data/radio_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const RadioScreen(),
    const Center(child: Text("Stations (Coming Soon)")),
    const RecordingsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final radioState = ref.watch(radioProvider);

    return Scaffold(
      body: Stack(
        children: [
          _screens[_selectedIndex],
          if (radioState.isRecording)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 20,
              right: 20,
              child: _RecordingIndicator(duration: radioState.recordingDuration),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
          border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.transparent,
          indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          destinations: [
            NavigationDestination(
              icon: Icon(PhosphorIcons.radio()),
              selectedIcon: Icon(PhosphorIcons.radio(PhosphorIconsStyle.fill)),
              label: 'Listen',
            ),
            NavigationDestination(
              icon: Icon(PhosphorIcons.broadcast()),
              selectedIcon: Icon(PhosphorIcons.broadcast(PhosphorIconsStyle.fill)),
              label: 'Stations',
            ),
            NavigationDestination(
              icon: Icon(PhosphorIcons.microphone()),
              selectedIcon: Icon(PhosphorIcons.microphone(PhosphorIconsStyle.fill)),
              label: 'Library',
            ),
            NavigationDestination(
              icon: Icon(PhosphorIcons.gear()),
              selectedIcon: Icon(PhosphorIcons.gear(PhosphorIconsStyle.fill)),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordingIndicator extends StatelessWidget {
  final Duration duration;
  const _RecordingIndicator({required this.duration});

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
          SizedBox(width: 8),
          Text(
            "REC  ${_formatDuration(duration)}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
