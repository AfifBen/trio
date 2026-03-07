import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  static const _habitsKey = 'trio_habits';
  static const _projectsKey = 'trio_projects';
  static const _pathsKey = 'trio_paths';
  static const _worksKey = 'trio_works';
  static const _localeKey = 'trio_locale';

  List<Goal> _goals = [];
  List<FocusSession> _sessions = [];
  bool _loaded = false;

  String? _trackName;
  String? _trackType; // reading | soft | hard
  int _trackDay = 1;
  int _trackTotal = 14;

  List<String> _habits = [];
  List<String> _projects = [];
  List<String> _paths = [];
  List<String> _works = [];

  Locale? _locale;

  List<Goal> get goals => _goals;
  List<FocusSession> get sessions => _sessions;
  bool get loaded => _loaded;

  String? get trackName => _trackName;
  String? get trackType => _trackType;
  int get trackDay => _trackDay;
  int get trackTotal => _trackTotal;
  bool get hasTrack => _trackName != null && _trackType != null;

  List<String> get habits => _habits;
  List<String> get projects => _projects;
  List<String> get paths => _paths;
  List<String> get works => _works;

  Locale? get locale => _locale;

  // Statistiques calculées
  int get totalMinutes => _sessions.fold(0, (sum, s) => sum + s.durationMinutes);

  int get sessionsToday => _sessions.where((s) => _isSameDay(s.timestamp, DateTime.now())).length;

  int goalsDoneByType(String type) =>
      _goals.where((g) => g.categoryType == type && g.completed).length;

  int goalsTotalByType(String type) =>
      _goals.where((g) => g.categoryType == type).length;

  int get goalsTotal => _goals.length;
  int get goalsCompleted => _goals.where((g) => g.completed).length;

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

    // Load Habits
    final rawHabits = prefs.getString(_habitsKey);
    if (rawHabits != null) {
      _habits = List<String>.from(jsonDecode(rawHabits) as List<dynamic>);
    }

    // Load Projects
    final rawProjects = prefs.getString(_projectsKey);
    if (rawProjects != null) {
      _projects = List<String>.from(jsonDecode(rawProjects) as List<dynamic>);
    }

    // Load Paths
    final rawPaths = prefs.getString(_pathsKey);
    if (rawPaths != null) {
      _paths = List<String>.from(jsonDecode(rawPaths) as List<dynamic>);
    }

    // Load Works
    final rawWorks = prefs.getString(_worksKey);
    if (rawWorks != null) {
      _works = List<String>.from(jsonDecode(rawWorks) as List<dynamic>);
    }

    // Load Locale
    final rawLocale = prefs.getString(_localeKey);
    if (rawLocale != null) {
      final parts = rawLocale.split('_');
      _locale = parts.length > 1 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
    }

    _loaded = true;
    notifyListeners();
  }

  Future<void> setGoals(List<String> titles, List<int> totals) async {
    _goals = List.generate(3, (index) {
      return Goal(
        id: 'goal_${index + 1}',
        title: titles[index],
        categoryType: 'work',
        categoryItem: 'Work',
        sessionsDone: 0,
        sessionsTotal: totals[index],
      );
    });
    await _persistGoals();
  }

  Future<void> setGoalsDetailed(List<Goal> goals) async {
    _goals = goals;
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

  Future<void> addHabit(String habit) async {
    _habits = [..._habits, habit];
    await _persistHabits();
  }

  Future<void> removeHabit(String habit) async {
    _habits = _habits.where((h) => h != habit).toList();
    await _persistHabits();
  }

  Future<void> addProject(String project) async {
    _projects = [..._projects, project];
    await _persistProjects();
  }

  Future<void> removeProject(String project) async {
    _projects = _projects.where((p) => p != project).toList();
    await _persistProjects();
  }

  Future<void> addPath(String path) async {
    _paths = [..._paths, path];
    await _persistPaths();
  }

  Future<void> removePath(String path) async {
    _paths = _paths.where((p) => p != path).toList();
    await _persistPaths();
  }

  Future<void> addWork(String work) async {
    _works = [..._works, work];
    await _persistWorks();
  }

  Future<void> removeWork(String work) async {
    _works = _works.where((w) => w != work).toList();
    await _persistWorks();
  }

  Future<void> ensureCategoryItem(String type, String item) async {
    if (item.trim().isEmpty) return;
    switch (type) {
      case 'habit':
        if (!_habits.contains(item)) {
          _habits = [..._habits, item];
          await _persistHabits();
        }
        break;
      case 'project':
        if (!_projects.contains(item)) {
          _projects = [..._projects, item];
          await _persistProjects();
        }
        break;
      case 'path':
        if (!_paths.contains(item)) {
          _paths = [..._paths, item];
          await _persistPaths();
        }
        break;
      case 'work':
      default:
        if (!_works.contains(item)) {
          _works = [..._works, item];
          await _persistWorks();
        }
        break;
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.toString());
    notifyListeners();
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

  Future<void> _persistHabits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_habitsKey, jsonEncode(_habits));
    notifyListeners();
  }

  Future<void> _persistProjects() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_projectsKey, jsonEncode(_projects));
    notifyListeners();
  }

  Future<void> _persistPaths() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pathsKey, jsonEncode(_paths));
    notifyListeners();
  }

  Future<void> _persistWorks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_worksKey, jsonEncode(_works));
    notifyListeners();
  }
}

