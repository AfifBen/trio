// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'TRIO';

  @override
  String get homeTagline => '3 goals. 1 focus. A winning day.';

  @override
  String get start => 'Start';

  @override
  String get openDashboard => 'Open dashboard';

  @override
  String get dashboardTitle => 'TRIO — Your 3 Wins';

  @override
  String get chooseGoal => 'Choose a goal and start a focus';

  @override
  String get startFocus => 'Start a focus';

  @override
  String get setGoalsTitle => 'Your 3 goals for today';

  @override
  String goalHint(Object index) {
    return 'Goal $index';
  }

  @override
  String get cyclesHint => 'Cycles';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get defineGoals => 'Define my goals';

  @override
  String get emptyGoals => 'Define your 3 goals to start';

  @override
  String get editGoalTitle => 'Edit this goal';

  @override
  String get newGoalHint => 'New goal';

  @override
  String get delete => 'Delete';

  @override
  String get deleteGoalConfirmTitle => 'Delete this goal?';

  @override
  String get deleteGoalConfirmBody =>
      'This will clear the goal and reset its counter.';

  @override
  String get focusTitle => 'Focus';

  @override
  String get focusMode => 'Zen mode · breathe and move forward';

  @override
  String get pausedMode => 'Paused · come back when ready';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get finish => 'Finish';

  @override
  String get rewardTitle => 'Focus complete!';

  @override
  String get rewardXp => '+120 Flow XP';

  @override
  String get debriefTitle => 'Voice debrief';

  @override
  String get debriefSubtitle => 'Tell me in a few words how it went.';

  @override
  String get record => 'Record (10s)';

  @override
  String get stop => 'Stop';

  @override
  String get insightTitle => 'AI Insight';

  @override
  String get backToDashboard => 'Back to dashboard';

  @override
  String get statsTitle => 'Stats & History';

  @override
  String get lastSessions => 'Latest Sessions';

  @override
  String get sessionsLabel => 'Sessions';

  @override
  String get minutesLabel => 'Minutes';

  @override
  String get streakLabel => 'Streak';

  @override
  String get weeklyActivity => '7-day activity';

  @override
  String get noSessions => 'No completed sessions yet.';

  @override
  String get completed => 'Completed';

  @override
  String get inProgress => 'In progress';

  @override
  String sessionsCount(Object done, Object total) {
    return '$done/$total sessions';
  }

  @override
  String get focusCompleteTitle => 'Focus complete 🎉';

  @override
  String focusCompleteBody(Object goal) {
    return 'Great job! You finished \"$goal\". Move to the next win.';
  }

  @override
  String get trackBlockTitle => 'Active path';

  @override
  String get trackNone => 'No active path';

  @override
  String get trackActivate => 'Activate';

  @override
  String get trackDeactivate => 'Stop path';

  @override
  String get trackDaily => 'Today';

  @override
  String get trackAdvance => 'Mark done';

  @override
  String get trackUseAsGoal => 'Use as Goal 1';

  @override
  String get trackDialogTitle => 'Activate a path';

  @override
  String get trackNameHint => 'Course or book name';

  @override
  String get trackTypeReading => 'Reading';

  @override
  String get trackTypeSoft => 'Soft skill';

  @override
  String get trackTypeHard => 'Hard skill';

  @override
  String get trackTotalHint => 'Days';
}
