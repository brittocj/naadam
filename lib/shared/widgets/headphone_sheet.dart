import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HeadphoneSheet extends StatelessWidget {
  final VoidCallback onSwitchToOnline;

  const HeadphoneSheet({super.key, required this.onSwitchToOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 32),
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              PhosphorIcons.headphones(),
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Headphones Required",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 12),
          Text(
            "Hardware FM radio needs wired headphones to act as an antenna. Please plug them in or use Online Radio.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onSwitchToOnline();
            },
            child: Text("SWITCH TO ONLINE RADIO"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("CANCEL", style: TextStyle(color: Colors.white24)),
          ),
        ],
      ),
    );
  }
}
