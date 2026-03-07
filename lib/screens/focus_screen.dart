import 'dart:async';
import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/notification_service.dart';
import 'reward_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FocusScreen extends StatefulWidget {
  final Goal goal;

  const FocusScreen({super.key, required this.goal});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  static const int _defaultMinutes = 25;
  late Duration _remaining;
  Timer? _timer;
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _remaining = const Duration(minutes: _defaultMinutes);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isRunning) return;
      if (_remaining.inSeconds <= 1) {
        timer.cancel();
        _finishSession();
      } else {
        setState(() {
          _remaining = _remaining - const Duration(seconds: 1);
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _finishSession() {
    final t = AppLocalizations.of(context)!;
    NotificationService.showFocusComplete(
      title: t.focusCompleteTitle,
      body: t.focusCompleteBody(widget.goal.title),
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RewardScreen(goal: widget.goal),
      ),
    );
  }

  String _format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E14),
        elevation: 0,
        title: Text(t.focusTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              widget.goal.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE0E0E0),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF00F0FF), width: 6),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3300F0FF),
                    blurRadius: 24,
                    spreadRadius: 8,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                _format(_remaining),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00F0FF),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              _isRunning ? t.focusMode : t.pausedMode,
              style: const TextStyle(color: Color(0xFF9AA4AF)),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _togglePause,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE0E0E0),
                      side: const BorderSide(color: Color(0xFF1E2A38)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(_isRunning ? t.pause : t.resume),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _finishSession,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8A2BE2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(t.finish),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
