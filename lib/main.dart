import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const TrioApp());
}

class TrioApp extends StatelessWidget {
  const TrioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRIO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0A0E14),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00F0FF),
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
