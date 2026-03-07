import 'package:flutter/material.dart';
import 'package:trio/l10n/app_localizations.dart';
import '../models/goal.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const GoalCard({super.key, required this.goal, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final progress = goal.sessionsTotal == 0
        ? 0.0
        : goal.sessionsDone / goal.sessionsTotal;

    final t = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFF131A24),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E2A38)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                goal.title.isEmpty ? t.emptyGoals : goal.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 6),
              _CategoryChip(label: _categoryLabel(t, goal)),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: progress,
                  backgroundColor: const Color(0xFF0A0E14),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    goal.completed
                        ? const Color(0xFFFFD700)
                        : const Color(0xFF00F0FF),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.sessionsCount(goal.sessionsDone, goal.sessionsTotal),
                    style: const TextStyle(color: Color(0xFF9AA4AF)),
                  ),
                  Text(
                    goal.completed ? t.completed : t.inProgress,
                    style: TextStyle(
                      color: goal.completed
                          ? const Color(0xFFFFD700)
                          : const Color(0xFF8A2BE2),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryLabel(AppLocalizations t, Goal goal) {
    final typeLabel = switch (goal.categoryType) {
      'project' => t.categoryProject,
      'habit' => t.categoryHabit,
      'path' => t.categoryPath,
      _ => t.categoryWork,
    };
    if (goal.categoryItem.isEmpty) return typeLabel;
    return '$typeLabel · ${goal.categoryItem}';
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;

  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E2A38)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Color(0xFF9AA4AF), fontSize: 12),
      ),
    );
  }
}
