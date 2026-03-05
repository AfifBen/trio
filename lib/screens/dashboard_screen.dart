import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../widgets/goal_card.dart';
import 'focus_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goals = const [
      Goal(title: 'Finaliser le design', sessionsDone: 2, sessionsTotal: 4),
      Goal(title: 'Envoyer les factures', sessionsDone: 1, sessionsTotal: 3),
      Goal(title: 'Préparer le pitch', sessionsDone: 0, sessionsTotal: 4),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E14),
        elevation: 0,
        title: const Text('TRIO — Tes 3 Victoires'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choisis un objectif et lance un Focus',
              style: TextStyle(color: Color(0xFF9AA4AF)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: goals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return GoalCard(
                    goal: goal,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FocusScreen(goal: goal),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00F0FF),
                  foregroundColor: const Color(0xFF0A0E14),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Démarrer un Focus'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
