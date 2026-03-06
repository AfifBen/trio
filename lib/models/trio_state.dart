import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'goal.dart';

class FocusSession {
  final String id;
  final String goalId;
  final String goalTitle;
  final DateTime timestamp;
  final int durationMinutes;
  final String transcript;

  FocusSession({
    required this.id,
    required this.goalId,
    required this.goalTitle,
    required this.timestamp,
    this.durationMinutes = 25,
    this.transcript = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'goalId': goalId,
        'goalTitle': goalTitle,
        'timestamp': timestamp.toIso8601String(),
        'durationMinutes': durationMinutes,
        'transcript': transcript,
      };

  factory FocusSession.fromJson(Map<String, dynamic> json) => FocusSession(
        id: json['id'],
        goalId: json['goalId'],
        goalTitle: json['goalTitle'],
        timestamp: DateTime.parse(json['timestamp']),
        durationMinutes: json['durationMinutes'] ?? 25,
        transcript: json['transcript'] ?? '',
      );
}

class TrioState extends ChangeNotifier {
  static const _goalsKey = 'trio_goals';
  static const _sessionsKey = 'trio_sessions';

  List<Goal> _goals = [];
  List<FocusSession> _sessions = [];
  bool _loaded = false;

  List<Goal> get goals => _goals;
  List<FocusSession> get sessions => _sessions;
  bool get loaded => _loaded;

  // Statistiques calculées
  int get totalMinutes => _sessions.fold(0, (sum, s) => sum + s.durationMinutes);
  int get sessionsToday => _sessions.where((s) => 
    s.timestamp.year == DateTime.now().year &&
    s.timestamp.month == DateTime.now().month &&
    s.timestamp.day == DateTime.now().day
  ).length;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    
    // Load Goals
    final rawGoals = prefs.getString(_goalsKey);
    if (rawGoals != null) {
      final decoded = jsonDecode(rawGoals) as List<dynamic>;
      _goals = decoded.map((item) => Goal.fromJson(item)).toList();
    }

    // Load Sessions
    final rawSessions = prefs.getString(_sessionsKey);
    if (rawSessions != null) {
      final decoded = jsonDecode(rawSessions) as List<dynamic>;
      _sessions = decoded.map((item) => FocusSession.fromJson(item)).toList();
    }

    _loaded = true;
    notifyListeners();
  }

  Future<void> setGoals(List<String> titles) async {
    _goals = List.generate(3, (index) {
      return Goal(
        id: 'goal_${index + 1}',
        title: titles[index],
        sessionsDone: 0,
        sessionsTotal: 4,
      );
    });
    await _persistGoals();
  }

  Future<void> updateGoalTitle(String goalId, String newTitle) async {
    _goals = _goals.map((g) {
      if (g.id != goalId) return g;
      return g.copyWith(title: newTitle);
    }).toList();
    await _persistGoals();
  }

  Future<void> resetGoal(String goalId) async {
    _goals = _goals.map((g) {
      if (g.id != goalId) return g;
      return g.copyWith(title: '', sessionsDone: 0);
    }).toList();
    await _persistGoals();
  }

  Future<void> addSession(String goalId, String transcript) async {
    final goal = _goals.firstWhere((g) => g.id == goalId);
    
    // 1. Ajouter la session à l'historique
    final newSession = FocusSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      goalId: goalId,
      goalTitle: goal.title,
      timestamp: DateTime.now(),
      transcript: transcript,
    );
    _sessions.add(newSession);

    // 2. Incrémenter le but
    _goals = _goals.map((g) {
      if (g.id != goalId) return g;
      return g.copyWith(sessionsDone: g.sessionsDone + 1);
    }).toList();

    await _persistGoals();
    await _persistSessions();
  }

  Future<void> _persistGoals() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_goalsKey, jsonEncode(_goals.map((g) => g.toJson()).toList()));
    notifyListeners();
  }

  Future<void> _persistSessions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionsKey, jsonEncode(_sessions.map((s) => s.toJson()).toList()));
    notifyListeners();
  }
}
