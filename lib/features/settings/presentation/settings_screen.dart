import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSection(context, "Audio", [
            _buildTile(context, "Streaming Quality", "High (192kbps)", PhosphorIcons.waves()),
            _buildTile(context, "Recording Format", "AAC (.m4a)", PhosphorIcons.fileAudio()),
          ]),
          SizedBox(height: 24),
          _buildSection(context, "Mode", [
            _buildTile(context, "Default Startup Mode", "Online FM", PhosphorIcons.radio()),
            _buildSwitchTile(context, "Auto-switch to Online", true, PhosphorIcons.arrowsLeftRight()),
          ]),
          SizedBox(height: 24),
          _buildSection(context, "Legal", [
            _buildTile(context, "Disclaimer", "Recording FM broadcasts...", PhosphorIcons.info()),
            _buildTile(context, "Privacy Policy", "Learn how we handle data", PhosphorIcons.shieldCheck()),
          ]),
          SizedBox(height: 40),
          Center(
            child: Text(
              "Naadam FM v1.0.0",
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTile(BuildContext context, String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white38)),
      trailing: Icon(PhosphorIcons.caretRight(), size: 16, color: Colors.white24),
      onTap: () {},
    );
  }

  Widget _buildSwitchTile(BuildContext context, String title, bool value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: (v) {},
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
