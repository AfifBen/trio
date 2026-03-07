import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:trio/l10n/app_localizations.dart';
import '../models/goal.dart';
import '../models/trio_state.dart';

class RewardScreen extends StatefulWidget {
  final Goal goal;

  const RewardScreen({super.key, required this.goal});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  late final ConfettiController _confettiController;
  final SpeechToText _speech = SpeechToText();
  bool _listening = false;
  String _transcript = '';

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }

    final available = await _speech.initialize();
    if (!available) return;

    setState(() => _listening = true);
    _speech.listen(
      onResult: (result) {
        setState(() => _transcript = result.recognizedWords);
      },
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
    );
  }

  String _buildInsight(AppLocalizations t) {
    if (_transcript.trim().isEmpty) {
      return t.focusCompleteBody(widget.goal.title);
    }

    final lower = _transcript.toLowerCase();
    if (lower.contains('bloqu') || lower.contains('difficile')) {
      return t.focusCompleteBody(widget.goal.title);
    }
    if (lower.contains('fini') || lower.contains('termin')) {
      return t.focusCompleteBody(widget.goal.title);
    }

    return t.focusCompleteBody(widget.goal.title);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E14),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 18,
                emissionFrequency: 0.2,
                gravity: 0.2,
                colors: const [
                  Color(0xFF00F0FF),
                  Color(0xFF8A2BE2),
                  Color(0xFFFFD700),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFFFFD700),
                    size: 80,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.rewardTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.rewardXp,
                    style: const TextStyle(
                      color: Color(0xFF00F0FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131A24),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF1E2A38)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.debriefTitle,
                          style: const TextStyle(color: Color(0xFFE0E0E0)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t.debriefSubtitle,
                          style: const TextStyle(color: Color(0xFF9AA4AF)),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _toggleRecording,
                            icon: Icon(_listening ? Icons.stop : Icons.mic),
                            label: Text(_listening ? t.stop : t.record),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFE0E0E0),
                              side: const BorderSide(color: Color(0xFF1E2A38)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        if (_transcript.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            _transcript,
                            style: const TextStyle(color: Color(0xFF9AA4AF)),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131A24),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF1E2A38)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.insightTitle,
                          style: const TextStyle(color: Color(0xFFE0E0E0)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _buildInsight(t),
                          style: const TextStyle(color: Color(0xFF9AA4AF)),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await context
                            .read<TrioState>()
                            .addSession(widget.goal.id, _transcript);
                        if (!mounted) return;
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00F0FF),
                        foregroundColor: const Color(0xFF0A0E14),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(t.backToDashboard),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
