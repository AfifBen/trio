import 'package:flutter/material.dart';
import '../models/goal.dart';

class RewardScreen extends StatelessWidget {
  final Goal goal;

  const RewardScreen({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E14),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFFFFD700),
                size: 80,
              ),
              const SizedBox(height: 16),
              const Text(
                'Focus terminé !',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '+120 Flow XP',
                style: TextStyle(
                  color: Color(0xFF00F0FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF131A24),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1E2A38)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Débrief vocal',
                      style: TextStyle(color: Color(0xFFE0E0E0)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Dis-moi en quelques mots comment ça s’est passé.',
                      style: TextStyle(color: Color(0xFF9AA4AF)),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.mic),
                        label: const Text('Enregistrer (10s)'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFE0E0E0),
                          side: const BorderSide(color: Color(0xFF1E2A38)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF131A24),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1E2A38)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Insight IA',
                      style: TextStyle(color: Color(0xFFE0E0E0)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bravo ! Tu as avancé sur "${goal.title}". '
                      'Une courte pause et tu es prêt pour le prochain round.',
                      style: const TextStyle(color: Color(0xFF9AA4AF)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00F0FF),
                    foregroundColor: const Color(0xFF0A0E14),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Retour au dashboard'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
