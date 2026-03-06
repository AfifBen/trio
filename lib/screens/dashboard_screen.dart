import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trio_state.dart';
import '../models/goal.dart';
import '../widgets/goal_card.dart';
import 'focus_screen.dart';
import 'stats_screen.dart';

class DashboardScreen extends StatefulWidget {
  final bool autoOpenDialog;

  const DashboardScreen({super.key, this.autoOpenDialog = false});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<TrioState>().load();
      if (widget.autoOpenDialog) {
        if (!mounted) return;
        _showGoalDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrioState>(
      builder: (context, trioState, _) {
        final goals = trioState.goals;

        return Scaffold(
          backgroundColor: const Color(0xFF0A0E14),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0A0E14),
            elevation: 0,
            title: const Text('TRIO — Tes 3 Victoires'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const StatsScreen()),
                  );
                },
                icon: const Icon(Icons.bar_chart, color: Color(0xFF00F0FF)),
              ),
              IconButton(
                onPressed: () => _showGoalDialog(context),
                icon: const Icon(Icons.edit, color: Color(0xFF9AA4AF)),
              ),
            ],
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
                  child: goals.isEmpty
                      ? _EmptyGoals(onStart: () => _showGoalDialog(context))
                      : ListView.separated(
                          itemCount: goals.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final goal = goals[index];
                            return GoalCard(
                              goal: goal,
                              onTap: () => _openFocus(context, goal),
                              onLongPress: () => _showSingleGoalEditDialog(context, goal),
                              onDelete: () => _confirmDeleteGoal(context, goal),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: goals.isEmpty
                        ? null
                        : () => _openFocus(context, goals.first),
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
      },
    );
  }

  void _openFocus(BuildContext context, Goal goal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FocusScreen(goal: goal),
      ),
    );
  }

  Future<void> _showGoalDialog(BuildContext context) async {
    final controllers = List.generate(3, (_) => TextEditingController());

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF131A24),
          title: const Text('Tes 3 objectifs du jour'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: controllers[index],
                  style: const TextStyle(color: Color(0xFFE0E0E0)),
                  decoration: InputDecoration(
                    hintText: 'Objectif ${index + 1}',
                    hintStyle: const TextStyle(color: Color(0xFF9AA4AF)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1E2A38)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF00F0FF)),
                    ),
                  ),
                ),
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final titles = controllers
                    .map((c) => c.text.trim())
                    .where((t) => t.isNotEmpty)
                    .toList();
                if (titles.length == 3) {
                  context.read<TrioState>().setGoals(titles);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00F0FF),
                foregroundColor: const Color(0xFF0A0E14),
              ),
              child: const Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSingleGoalEditDialog(BuildContext context, Goal goal) async {
    final controller = TextEditingController(text: goal.title);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF131A24),
          title: const Text('Modifier cet objectif'),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Color(0xFFE0E0E0)),
            decoration: InputDecoration(
              hintText: 'Nouvel objectif',
              hintStyle: const TextStyle(color: Color(0xFF9AA4AF)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1E2A38)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00F0FF)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmDeleteGoal(context, goal);
              },
              child: const Text('Supprimer', style: TextStyle(color: Color(0xFFFF6B6B))),
            ),
            ElevatedButton(
              onPressed: () {
                final newTitle = controller.text.trim();
                if (newTitle.isNotEmpty) {
                  context.read<TrioState>().updateGoalTitle(goal.id, newTitle);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00F0FF),
                foregroundColor: const Color(0xFF0A0E14),
              ),
              child: const Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteGoal(BuildContext context, Goal goal) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131A24),
        title: const Text('Supprimer cet objectif ?'),
        content: const Text(
          'Cette action efface l\'objectif et remet son compteur à zéro.',
          style: TextStyle(color: Color(0xFF9AA4AF)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TrioState>().resetGoal(goal.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}


class _EmptyGoals extends StatelessWidget {
  final VoidCallback onStart;

  const _EmptyGoals({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star_border, color: Color(0xFF8A2BE2), size: 48),
          const SizedBox(height: 12),
          const Text(
            'Définis tes 3 objectifs pour commencer',
            style: TextStyle(color: Color(0xFFE0E0E0)),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8A2BE2),
              foregroundColor: Colors.white,
            ),
            child: const Text('Définir mes objectifs'),
          ),
        ],
      ),
    );
  }
}
