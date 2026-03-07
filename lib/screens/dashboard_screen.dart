import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trio_state.dart';
import '../models/goal.dart';
import '../widgets/goal_card.dart';
import 'focus_screen.dart';
import 'stats_screen.dart';
import 'package:trio/l10n/app_localizations.dart';

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

  String _generateDescription(
    AppLocalizations t,
    String title,
    String category,
    String type,
  ) {
    final item = category.isNotEmpty ? category : title;
    return switch (type) {
      'project' => t.generatedProject(item),
      'habit' => t.generatedHabit(item),
      'path' => t.generatedPath(item),
      _ => t.generatedWork(item),
    };
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
                      : ListView(
                          children: [
                            _TrackBlock(
                              hasTrack: trioState.hasTrack,
                              title: trioState.trackName ?? '',
                              daily: trioState.trackDailyObjective(),
                              day: trioState.trackDay,
                              total: trioState.trackTotal,
                              onActivate: () => _showTrackDialog(context),
                              onDeactivate: () => trioState.clearTrack(),
                              onAdvance: () => trioState.advanceTrack(),
                              onUseAsGoal: () => _useTrackAsGoal(context),
                            ),
                            const SizedBox(height: 12),
                            ...goals.map((goal) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Dismissible(
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
                                ),
                              );
                            }).toList(),
                          ],
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

  void _useTrackAsGoal(BuildContext context) {
    final trioState = context.read<TrioState>();
    if (!trioState.hasTrack) return;
    if (trioState.goals.isEmpty) return;
    final updated = trioState.goals.first.copyWith(
      title: '${trioState.trackDailyObjective()} · ${trioState.trackName}',
    );
    trioState.updateGoalTitle(updated.id, updated.title);
  }

  Future<void> _showTrackDialog(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final totalController = TextEditingController(text: '14');
    String type = 'reading';

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF131A24),
          title: Text(t.trackDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Color(0xFFE0E0E0)),
                decoration: InputDecoration(
                  hintText: t.trackNameHint,
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
              DropdownButtonFormField<String>(
                value: type,
                dropdownColor: const Color(0xFF131A24),
                items: [
                  DropdownMenuItem(value: 'reading', child: Text(t.trackTypeReading)),
                  DropdownMenuItem(value: 'soft', child: Text(t.trackTypeSoft)),
                  DropdownMenuItem(value: 'hard', child: Text(t.trackTypeHard)),
                ],
                onChanged: (val) => type = val ?? 'reading',
                decoration: InputDecoration(
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
                  hintText: t.trackTotalHint,
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
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final total = int.tryParse(totalController.text.trim()) ?? 14;
                if (name.isNotEmpty) {
                  context.read<TrioState>().setTrack(
                        name: name,
                        type: type,
                        total: total,
                      );
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

  Future<void> _showGoalDialog(BuildContext context) async {
    final titleControllers = List.generate(3, (_) => TextEditingController());
    final totalControllers = List.generate(3, (_) => TextEditingController(text: '4'));
    final categoryControllers = List.generate(3, (_) => TextEditingController());
    final descriptionControllers = List.generate(3, (_) => TextEditingController());
    final categories = List.generate(3, (_) => 'project');

    final t = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF131A24),
          title: Text(t.setGoalsTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      Row(
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
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: categories[index],
                              dropdownColor: const Color(0xFF131A24),
                              items: [
                                DropdownMenuItem(value: 'project', child: Text(t.categoryProject)),
                                DropdownMenuItem(value: 'habit', child: Text(t.categoryHabit)),
                                DropdownMenuItem(value: 'path', child: Text(t.categoryPath)),
                                DropdownMenuItem(value: 'work', child: Text(t.categoryWork)),
                              ],
                              onChanged: (val) => categories[index] = val ?? 'project',
                              decoration: InputDecoration(
                                hintText: t.goalCategoryHint,
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
                              controller: categoryControllers[index],
                              style: const TextStyle(color: Color(0xFFE0E0E0)),
                              decoration: InputDecoration(
                                hintText: t.categoryItemHint,
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
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: descriptionControllers[index],
                              style: const TextStyle(color: Color(0xFFE0E0E0)),
                              decoration: InputDecoration(
                                hintText: t.descriptionHint,
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
                          OutlinedButton(
                            onPressed: () {
                              final title = titleControllers[index].text.trim();
                              final category = categoryControllers[index].text.trim();
                              descriptionControllers[index].text =
                                  _generateDescription(t, title, category, categories[index]);
                            },
                            child: Text(t.generate),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final rows = List.generate(3, (index) {
                  return {
                    'title': titleControllers[index].text.trim(),
                    'total': int.tryParse(totalControllers[index].text.trim()) ?? 4,
                    'categoryType': categories[index],
                    'categoryItem': categoryControllers[index].text.trim(),
                    'description': descriptionControllers[index].text.trim(),
                  };
                }).where((row) => (row['title'] as String).isNotEmpty).toList();

                if (rows.isEmpty) return;
                if (rows.any((row) => (row['categoryItem'] as String).isEmpty)) {
                  return;
                }

                final goals = List.generate(rows.length, (index) {
                  final row = rows[index];
                  return Goal(
                    id: 'goal_${index + 1}',
                    title: row['title'] as String,
                    categoryType: row['categoryType'] as String,
                    categoryItem: row['categoryItem'] as String,
                    description: row['description'] as String,
                    sessionsDone: 0,
                    sessionsTotal: row['total'] as int,
                  );
                });

                final trio = context.read<TrioState>();
                for (final goal in goals) {
                  await trio.ensureCategoryItem(goal.categoryType, goal.categoryItem);
                }

                await trio.setGoalsDetailed(goals);
                if (context.mounted) Navigator.of(context).pop();
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
    final categoryController = TextEditingController(text: goal.categoryItem);
    final descriptionController = TextEditingController(text: goal.description);
    String categoryType = goal.categoryType;

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
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: categoryType,
                      dropdownColor: const Color(0xFF131A24),
                      items: [
                        DropdownMenuItem(value: 'project', child: Text(t.categoryProject)),
                        DropdownMenuItem(value: 'habit', child: Text(t.categoryHabit)),
                        DropdownMenuItem(value: 'path', child: Text(t.categoryPath)),
                        DropdownMenuItem(value: 'work', child: Text(t.categoryWork)),
                      ],
                      onChanged: (val) => categoryType = val ?? 'project',
                      decoration: InputDecoration(
                        hintText: t.goalCategoryHint,
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
                      controller: categoryController,
                      style: const TextStyle(color: Color(0xFFE0E0E0)),
                      decoration: InputDecoration(
                        hintText: t.categoryItemHint,
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: descriptionController,
                      style: const TextStyle(color: Color(0xFFE0E0E0)),
                      decoration: InputDecoration(
                        hintText: t.descriptionHint,
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
                  OutlinedButton(
                    onPressed: () {
                      final title = titleController.text.trim();
                      final category = categoryController.text.trim();
                      descriptionController.text =
                          _generateDescription(t, title, category, categoryType);
                    },
                    child: Text(t.generate),
                  ),
                ],
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
              onPressed: () async {
                final newTitle = titleController.text.trim();
                final newTotal = int.tryParse(totalController.text.trim()) ?? goal.sessionsTotal;
                final newCategoryItemRaw = categoryController.text.trim();
                if (newTitle.isEmpty) return;

                final newCategoryItem =
                    newCategoryItemRaw.isEmpty ? goal.categoryItem : newCategoryItemRaw;

                final trio = context.read<TrioState>();
                await trio.ensureCategoryItem(categoryType, newCategoryItem);
                final updated = goal.copyWith(
                  title: newTitle,
                  sessionsTotal: newTotal,
                  categoryType: categoryType,
                  categoryItem: newCategoryItem,
                  description: descriptionController.text.trim(),
                );
                await trio.setGoalsDetailed(
                  trio.goals.map((g) => g.id == updated.id ? updated : g).toList(),
                );
                if (context.mounted) Navigator.of(context).pop();
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

class _TrackBlock extends StatelessWidget {
  final bool hasTrack;
  final String title;
  final String daily;
  final int day;
  final int total;
  final VoidCallback onActivate;
  final VoidCallback onDeactivate;
  final VoidCallback onAdvance;
  final VoidCallback onUseAsGoal;

  const _TrackBlock({
    required this.hasTrack,
    required this.title,
    required this.daily,
    required this.day,
    required this.total,
    required this.onActivate,
    required this.onDeactivate,
    required this.onAdvance,
    required this.onUseAsGoal,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131A24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E2A38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.trackBlockTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              if (hasTrack)
                TextButton(
                  onPressed: onDeactivate,
                  child: Text(t.trackDeactivate),
                ),
            ],
          ),
          const SizedBox(height: 6),
          if (!hasTrack) ...[
            Text(
              t.trackNone,
              style: const TextStyle(color: Color(0xFF9AA4AF)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onActivate,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE0E0E0),
                side: const BorderSide(color: Color(0xFF1E2A38)),
              ),
              child: Text(t.trackActivate),
            ),
          ] else ...[
            Text(
              title,
              style: const TextStyle(color: Color(0xFFE0E0E0)),
            ),
            const SizedBox(height: 6),
            Text(
              '${t.trackDaily}: $daily',
              style: const TextStyle(color: Color(0xFF9AA4AF)),
            ),
            const SizedBox(height: 6),
            Text(
              'Day $day / $total',
              style: const TextStyle(color: Color(0xFF00F0FF)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onAdvance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A2BE2),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(t.trackAdvance),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onUseAsGoal,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE0E0E0),
                    side: const BorderSide(color: Color(0xFF1E2A38)),
                  ),
                  child: Text(t.trackUseAsGoal),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
