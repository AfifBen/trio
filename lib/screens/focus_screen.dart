import 'package:flutter/material.dart';
import '../models/goal.dart';
import 'reward_screen.dart';

class FocusScreen extends StatelessWidget {
  final Goal goal;

  const FocusScreen({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E14),
        elevation: 0,
        title: const Text('Focus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              goal.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE0E0E0),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF00F0FF), width: 6),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3300F0FF),
                    blurRadius: 24,
                    spreadRadius: 8,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                '25:00',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00F0FF),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Mode Zen · Respire et avance',
              style: TextStyle(color: Color(0xFF9AA4AF)),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE0E0E0),
                      side: const BorderSide(color: Color(0xFF1E2A38)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Pause'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RewardScreen(goal: goal),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8A2BE2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Terminer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
