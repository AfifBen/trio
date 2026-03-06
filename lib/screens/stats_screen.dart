import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trio_state.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TrioState>(
      builder: (context, state, _) {
        final sessions = state.sessions.reversed.toList();

        return Scaffold(
          backgroundColor: const Color(0xFF0A0E14),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0A0E14),
            elevation: 0,
            title: const Text('Statistiques & Historique'),
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
                        'Sessions',
                        '${state.sessions.length}',
                        Icons.timer,
                        const Color(0xFF00F0FF),
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        'Minutes',
                        '${state.totalMinutes}',
                        Icons.bolt,
                        const Color(0xFF8A2BE2),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Dernières Sessions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                ),
              ),

              // Liste de l'historique
              sessions.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Aucune session terminée pour le moment.',
                          style: TextStyle(color: Color(0xFF9AA4AF)),
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
