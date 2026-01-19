import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';

class RecordingsScreen extends StatefulWidget {
  const RecordingsScreen({super.key});

  @override
  State<RecordingsScreen> createState() => _RecordingsScreenState();
}

class _RecordingsScreenState extends State<RecordingsScreen> {
  List<FileSystemEntity> _files = [];

  @override
  void initState() {
    super.initState();
    _loadRecordings();
  }

  Future<void> _loadRecordings() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync().where((file) => file.path.endsWith(".m4a")).toList();
    setState(() {
      _files = files.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recordings Library", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.arrowsClockwise()),
            onPressed: _loadRecordings,
          ),
        ],
      ),
      body: _files.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(PhosphorIcons.microphoneSlash(), size: 80, color: Colors.white10),
                  SizedBox(height: 16),
                  Text("No recordings found", style: TextStyle(color: Colors.white54)),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _files.length,
              itemBuilder: (context, index) {
                final file = _files[index];
                final name = file.path.split("/").last;
                final date = file.statSync().modified;
                final size = file.statSync().size;

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(PhosphorIcons.waveform(), color: Theme.of(context).colorScheme.primary),
                    ),
                    title: Text(name),
                    subtitle: Text(
                      "${DateFormat('MMM dd, yyyy • HH:mm').format(date)} • ${(size / 1024).toStringAsFixed(1)} KB",
                    ),
                    trailing: Icon(PhosphorIcons.play(PhosphorIconsStyle.fill)),
                    onTap: () {
                      // Play recording logic
                    },
                  ),
                );
              },
            ),
    );
  }
}
