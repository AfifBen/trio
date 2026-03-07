import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trio_state.dart';
import '../models/goal.dart';
import '../widgets/goal_card.dart';
import 'focus_screen.dart';
import 'stats_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

        final t = AppLocalizations.of(context)!;

        return Scaffold(
          backgroundColor: const Color(0xFF0A0E14),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0A0E14),
            elevation: 0,
            title: Text(t.dashboardTitle),
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
                Text(
                  t.chooseGoal,
                  style: const TextStyle(color: Color(0xFF9AA4AF)),
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
                            return Dismissible(
                              key: ValueKey(goal.id),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (_) => _confirmDeleteGoal(context, goal),
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B6B),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              child: GoalCard(
                                goal: goal,
                                onTap: () => _openFocus(context, goal),
                                onLongPress: () => _showSingleGoalEditDialog(context, goal),
                              ),
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
                    child: Text(t.startFocus),
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
    final titleControllers = List.generate(3, (_) => TextEditingController());
    final totalControllers = List.generate(3, (_) => TextEditingController(text: '4'));

    final t = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF131A24),
          title: Text(t.setGoalsTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: titleControllers[index],
                        style: const TextStyle(color: Color(0xFFE0E0E0)),
                        decoration: InputDecoration(
                          hintText: t.goalHint(index + 1),
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
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: totalControllers[index],
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Color(0xFFE0E0E0)),
                        decoration: InputDecoration(
                          hintText: t.cyclesHint,
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
                    ),
                  ],
                ),
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final titles = titleControllers
                    .map((c) => c.text.trim())
                    .where((t) => t.isNotEmpty)
                    .toList();
                final totals = totalControllers
                    .map((c) => int.tryParse(c.text.trim()) ?? 4)
                    .toList();
                if (titles.length == 3 && totals.length == 3) {
                  context.read<TrioState>().setGoals(titles, totals);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00F0FF),
                foregroundColor: const Color(0xFF0A0E14),
              ),
              child: Text(t.save),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSingleGoalEditDialog(BuildContext context, Goal goal) async {
    final titleController = TextEditingController(text: goal.title);
    final totalController = TextEditingController(text: goal.sessionsTotal.toString());

    final t = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF131A24),
          title: Text(t.editGoalTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Color(0xFFE0E0E0)),
                decoration: InputDecoration(
                  hintText: t.newGoalHint,
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
              const SizedBox(height: 8),
              TextField(
                controller: totalController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Color(0xFFE0E0E0)),
                decoration: InputDecoration(
                  hintText: t.cyclesHint,
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmDeleteGoal(context, goal);
              },
              child: Text(t.delete, style: const TextStyle(color: Color(0xFFFF6B6B))),
            ),
            ElevatedButton(
              onPressed: () {
                final newTitle = titleController.text.trim();
                final newTotal = int.tryParse(totalController.text.trim()) ?? goal.sessionsTotal;
                if (newTitle.isNotEmpty) {
                  context.read<TrioState>().updateGoalTitle(goal.id, newTitle);
                  context.read<TrioState>().updateGoalTotal(goal.id, newTotal);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00F0FF),
                foregroundColor: const Color(0xFF0A0E14),
              ),
              child: Text(t.save),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _confirmDeleteGoal(BuildContext context, Goal goal) async {
    final t = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131A24),
        title: Text(t.deleteGoalConfirmTitle),
        content: Text(
          t.deleteGoalConfirmBody,
          style: const TextStyle(color: Color(0xFF9AA4AF)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TrioState>().resetGoal(goal.id);
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
            ),
            child: Text(t.delete),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}


class _EmptyGoals extends StatelessWidget {
  final VoidCallback onStart;

  const _EmptyGoals({required this.onStart});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star_border, color: Color(0xFF8A2BE2), size: 48),
          const SizedBox(height: 12),
          Text(
            t.emptyGoals,
            style: const TextStyle(color: Color(0xFFE0E0E0)),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8A2BE2),
              foregroundColor: Colors.white,
            ),
            child: Text(t.defineGoals),
          ),
        ],
      ),
    );
  }
}
