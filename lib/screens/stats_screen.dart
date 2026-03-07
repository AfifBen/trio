import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:trio/l10n/app_localizations.dart';
import '../models/trio_state.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TrioState>(
      builder: (context, state, _) {
        final sessions = state.sessions.reversed.toList();
        final weekly = state.last7DaysSessions();

        final t = AppLocalizations.of(context)!;

        return Scaffold(
          backgroundColor: const Color(0xFF0A0E14),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0A0E14),
            elevation: 0,
            title: Text(t.statsTitle),
          ),
          body: CustomScrollView(
            slivers: [
              // Section Résumé (Cartes)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildStatCard(
                        t.sessionsLabel,
                        '${state.sessions.length}',
                        Icons.timer,
                        const Color(0xFF00F0FF),
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        t.minutesLabel,
                        '${state.totalMinutes}',
                        Icons.bolt,
                        const Color(0xFF8A2BE2),
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        t.streakLabel,
                        '${state.streakDays}j',
                        Icons.local_fire_department,
                        const Color(0xFFFFD700),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _WeeklyChart(weekly: weekly),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    t.lastSessions,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                ),
              ),

              // Liste de l'historique
              sessions.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text(
                          t.noSessions,
                          style: const TextStyle(color: Color(0xFF9AA4AF)),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final session = sessions[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                                    Expanded(
                                      child: Text(
                                        session.goalTitle,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFE0E0E0),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${session.timestamp.day}/${session.timestamp.month}',
                                      style: const TextStyle(
                                        color: Color(0xFF9AA4AF),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                if (session.transcript.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    '“${session.transcript}”',
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFF00F0FF),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                        childCount: sessions.length,
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF131A24),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF1E2A38)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF9AA4AF), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<int> weekly;

  const _WeeklyChart({required this.weekly});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final maxVal = weekly.isEmpty ? 1 : weekly.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131A24),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1E2A38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.weeklyActivity,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE0E0E0),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            labels[value.toInt() % 7],
                            style: const TextStyle(color: Color(0xFF9AA4AF), fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(7, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: weekly[index].toDouble(),
                        width: 12,
                        color: const Color(0xFF00F0FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  );
                }),
                maxY: (maxVal + 1).toDouble(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
