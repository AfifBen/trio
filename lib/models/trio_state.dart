import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'goal.dart';

class TrioState extends ChangeNotifier {
  static const _goalsKey = 'trio_goals';

  List<Goal> _goals = [];
  bool _loaded = false;

  List<Goal> get goals => _goals;
  bool get loaded => _loaded;

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_goalsKey);
    if (raw != null) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _goals = decoded
          .map((item) => Goal.fromJson(item as Map<String, dynamic>))
          .toList();
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
    await _persist();
  }

  Future<void> incrementSession(String goalId) async {
    _goals = _goals.map((goal) {
      if (goal.id != goalId) return goal;
      final nextCount = goal.sessionsDone + 1;
      return goal.copyWith(sessionsDone: nextCount);
    }).toList();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_goals.map((g) => g.toJson()).toList());
    await prefs.setString(_goalsKey, raw);
    notifyListeners();
  }
}
