import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trio/l10n/app_localizations.dart';
import '../models/trio_state.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TrioState>().load());
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E14),
      body: SafeArea(
        child: Consumer<TrioState>(
          builder: (context, state, _) {
            return Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TRIO',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: Color(0xFFE6EDF3),
                        ),
                      ),
                      _LanguageMenu(
                        currentLocale: state.locale?.languageCode,
                        onSelect: (locale) => state.setLocale(locale),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    t.homeTagline,
                    style: const TextStyle(color: Color(0xFF9AA4AF), fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    t.todayTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE6EDF3),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: state.goals.isEmpty
                        ? _EmptyState(onAdd: () => _openDashboard(context))
                        : ListView.separated(
                            itemCount: state.goals.length.clamp(0, 3),
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final goal = state.goals[index];
                              final progress = goal.sessionsTotal == 0
                                  ? 0.0
                                  : goal.sessionsDone / goal.sessionsTotal;
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF101826),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFF1E2A38)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      goal.title.isEmpty ? t.emptyGoals : goal.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFE6EDF3),
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
                                        valueColor: const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF00F0FF),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      t.sessionsCount(goal.sessionsDone, goal.sessionsTotal),
                                      style: const TextStyle(color: Color(0xFF9AA4AF)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _openDashboard(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00F0FF),
                        foregroundColor: const Color(0xFF0A0E14),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(t.startFocus),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _openDashboard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  String _categoryLabel(AppLocalizations t, dynamic goal) {
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

class _LanguageMenu extends StatelessWidget {
  final String? currentLocale;
  final ValueChanged<Locale> onSelect;

  const _LanguageMenu({
    required this.currentLocale,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language, color: Color(0xFF9AA4AF)),
      onSelected: onSelect,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
        const PopupMenuItem(
          value: Locale('fr'),
          child: Text('Français'),
        ),
        const PopupMenuItem(
          value: Locale('ar'),
          child: Text('العربية'),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, color: Color(0xFF1E2A38), size: 64),
          const SizedBox(height: 12),
          Text(
            t.emptyGoals,
            style: const TextStyle(color: Color(0xFF9AA4AF)),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onAdd,
            child: Text(t.openDashboard),
          ),
        ],
      ),
    );
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
