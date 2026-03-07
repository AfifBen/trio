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
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
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
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    t.homeTagline,
                    style: const TextStyle(color: Color(0xFF9AA4AF), fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF101826), Color(0xFF0E1420)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF1E2A38)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3300F0FF),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
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
                                    color: Color(0xFFFFD54F), size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  '${state.streakDays}d',
                                  style: const TextStyle(
                                    color: Color(0xFFFFD54F),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _StatChip(
                              label: t.statsSessionsToday,
                              value: '${state.sessionsToday}',
                              icon: Icons.timer,
                            ),
                            _StatChip(
                              label: t.statsMinutes,
                              value: '${state.totalMinutes}',
                              icon: Icons.bolt,
                            ),
                            _StatChip(
                              label: t.statsGoals,
                              value: '${state.goalsCompleted}/${state.goalsTotal}',
                              icon: Icons.flag,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    t.progressOverview,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE6EDF3),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ProgressCard(
                    title: t.projectsTitle,
                    count: state.projects.length,
                    done: state.goalsDoneByType('project'),
                    total: state.goalsTotalByType('project'),
                    icon: Icons.work_outline,
                  ),
                  const SizedBox(height: 10),
                  _ProgressCard(
                    title: t.habitsTitle,
                    count: state.habits.length,
                    done: state.goalsDoneByType('habit'),
                    total: state.goalsTotalByType('habit'),
                    icon: Icons.check_circle_outline,
                  ),
                  const SizedBox(height: 10),
                  _ProgressCard(
                    title: t.pathsTitle,
                    count: state.paths.length,
                    done: state.goalsDoneByType('path'),
                    total: state.goalsTotalByType('path'),
                    icon: Icons.route,
                  ),
                  const SizedBox(height: 10),
                  _ProgressCard(
                    title: t.workTitle,
                    count: state.works.length,
                    done: state.goalsDoneByType('work'),
                    total: state.goalsTotalByType('work'),
                    icon: Icons.business_center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const DashboardScreen()),
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
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E2A38)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF00F0FF)),
          const SizedBox(width: 6),
          Text(
            '$value · $label',
            style: const TextStyle(color: Color(0xFF9AA4AF), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String title;
  final int count;
  final int done;
  final int total;
  final IconData icon;

  const _ProgressCard({
    required this.title,
    required this.count,
    required this.done,
    required this.total,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : done / total;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF101826),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E2A38)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0E14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 18, color: const Color(0xFF00F0FF)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFE6EDF3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$count',
                style: const TextStyle(color: Color(0xFF9AA4AF)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress,
              backgroundColor: const Color(0xFF0A0E14),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00F0FF)),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$done/$total',
              style: const TextStyle(color: Color(0xFF9AA4AF), fontSize: 12),
            ),
          ),
        ],
      ),
    );
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
