import 'package:flutter/material.dart';
import 'package:trio/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/trio_state.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E14),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'TRIO',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                t.homeTagline,
                style: const TextStyle(color: Color(0xFF9AA4AF), fontSize: 16),
              ),
              const SizedBox(height: 20),
              Consumer<TrioState>(
                builder: (context, state, _) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131A24),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF1E2A38)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.homeStreak,
                              style: const TextStyle(color: Color(0xFF9AA4AF)),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.local_fire_department,
                                    color: Color(0xFFFFD700), size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  '${state.streakDays}d',
                                  style: const TextStyle(
                                    color: Color(0xFFFFD700),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _miniCard(
                              icon: Icons.check_circle_outline,
                              title: t.habitsTitle,
                              subtitle: state.habits.isEmpty
                                  ? t.emptyHabits
                                  : state.habits.first,
                            ),
                            const SizedBox(width: 12),
                            _miniCard(
                              icon: Icons.work_outline,
                              title: t.projectsTitle,
                              subtitle: state.projects.isEmpty
                                  ? t.emptyProjects
                                  : state.projects.first,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () => _addHabit(context),
                              child: Text(t.addHabit),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () => _addProject(context),
                              child: Text(t.addProject),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DashboardScreen(autoOpenDialog: true),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00F0FF),
                    foregroundColor: const Color(0xFF0A0E14),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(t.start),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const DashboardScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE0E0E0),
                    side: const BorderSide(color: Color(0xFF1E2A38)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(t.openDashboard),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0E14),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E2A38)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF00F0FF), size: 20),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Color(0xFFE0E0E0)),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xFF9AA4AF), fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addHabit(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131A24),
        title: Text(t.addHabit),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Color(0xFFE0E0E0)),
          decoration: const InputDecoration(
            hintText: 'Ex: 10 min lecture',
            hintStyle: TextStyle(color: Color(0xFF9AA4AF)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                context.read<TrioState>().addHabit(value);
                Navigator.of(context).pop();
              }
            },
            child: Text(t.save),
          )
        ],
      ),
    );
  }

  Future<void> _addProject(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final controller = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131A24),
        title: Text(t.addProject),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Color(0xFFE0E0E0)),
          decoration: const InputDecoration(
            hintText: 'Ex: Lancer la V1',
            hintStyle: TextStyle(color: Color(0xFF9AA4AF)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                context.read<TrioState>().addProject(value);
                Navigator.of(context).pop();
              }
            },
            child: Text(t.save),
          )
        ],
      ),
    );
  }
}
