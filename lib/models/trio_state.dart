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
  static const _trackKey = 'trio_track';

  List<Goal> _goals = [];
  List<FocusSession> _sessions = [];
  bool _loaded = false;

  String? _trackName;
  String? _trackType; // reading | soft | hard
  int _trackDay = 1;
  int _trackTotal = 14;

  List<Goal> get goals => _goals;
  List<FocusSession> get sessions => _sessions;
  bool get loaded => _loaded;

  String? get trackName => _trackName;
  String? get trackType => _trackType;
  int get trackDay => _trackDay;
  int get trackTotal => _trackTotal;
  bool get hasTrack => _trackName != null && _trackType != null;

  // Statistiques calculées
  int get totalMinutes => _sessions.fold(0, (sum, s) => sum + s.durationMinutes);

  int get sessionsToday => _sessions.where((s) => _isSameDay(s.timestamp, DateTime.now())).length;

  int get streakDays {
    if (_sessions.isEmpty) return 0;
    final sessionDays = _sessions
        .map((s) => _dayOnly(s.timestamp))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime cursor = _dayOnly(DateTime.now());
    for (final day in sessionDays) {
      if (day == cursor) {
        streak += 1;
        cursor = cursor.subtract(const Duration(days: 1));
      } else if (day.isAfter(cursor)) {
        continue;
      } else {
        break;
      }
    }
    return streak;
  }

  List<int> last7DaysSessions() {
    final today = _dayOnly(DateTime.now());
    final counts = List<int>.filled(7, 0);

    for (final session in _sessions) {
      final day = _dayOnly(session.timestamp);
      final diff = today.difference(day).inDays;
      if (diff >= 0 && diff < 7) {
        counts[6 - diff] += 1; // oldest -> newest
      }
    }
    return counts;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  DateTime _dayOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

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

    // Load Track
    final rawTrack = prefs.getString(_trackKey);
    if (rawTrack != null) {
      final decoded = jsonDecode(rawTrack) as Map<String, dynamic>;
      _trackName = decoded['name'];
      _trackType = decoded['type'];
      _trackDay = decoded['day'] ?? 1;
      _trackTotal = decoded['total'] ?? 14;
    }

    _loaded = true;
    notifyListeners();
  }

  Future<void> setGoals(List<String> titles, List<int> totals) async {
    _goals = List.generate(3, (index) {
      return Goal(
        id: 'goal_${index + 1}',
        title: titles[index],
        sessionsDone: 0,
        sessionsTotal: totals[index],
      );
    });
    await _persistGoals();
  }

  Future<void> updateGoalTotal(String goalId, int total) async {
    _goals = _goals.map((g) {
      if (g.id != goalId) return g;
      return g.copyWith(sessionsTotal: total);
    }).toList();
    await _persistGoals();
  }

  Future<void> setTrack({
    required String name,
    required String type,
    required int total,
  }) async {
    _trackName = name;
    _trackType = type;
    _trackTotal = total;
    _trackDay = 1;
    await _persistTrack();
  }

  Future<void> clearTrack() async {
    _trackName = null;
    _trackType = null;
    _trackDay = 1;
    _trackTotal = 14;
    await _persistTrack();
  }

  Future<void> advanceTrack() async {
    if (!hasTrack) return;
    if (_trackDay < _trackTotal) {
      _trackDay += 1;
    }
    await _persistTrack();
  }

  String trackDailyObjective() {
    if (!hasTrack) return '';
    switch (_trackType) {
      case 'reading':
        return 'Read 10 pages · Day $_trackDay/$_trackTotal';
      case 'soft':
        return 'Practice a soft skill · Day $_trackDay/$_trackTotal';
      case 'hard':
        return 'Complete a training module · Day $_trackDay/$_trackTotal';
      default:
        return 'Daily progress · Day $_trackDay/$_trackTotal';
    }
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

  Future<void> _persistTrack() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = _trackName == null
        ? null
        : jsonEncode({
            'name': _trackName,
            'type': _trackType,
            'day': _trackDay,
            'total': _trackTotal,
          });
    if (payload == null) {
      await prefs.remove(_trackKey);
    } else {
      await prefs.setString(_trackKey, payload);
    }
    notifyListeners();
  }
}

