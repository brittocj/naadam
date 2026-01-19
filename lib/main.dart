import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme.dart';
import 'features/radio/presentation/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: const NaadamApp(),
    ),
  );
}

class NaadamApp extends StatelessWidget {
  const NaadamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naadam FM',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
