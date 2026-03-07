// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'TRIO';

  @override
  String get homeTagline => '3 objectifs. 1 focus. Une journée gagnée.';

  @override
  String get start => 'Commencer';

  @override
  String get openDashboard => 'Accéder au tableau de bord';

  @override
  String get dashboardTitle => 'TRIO — Tes 3 Victoires';

  @override
  String get chooseGoal => 'Choisis un objectif et lance un Focus';

  @override
  String get startFocus => 'Démarrer un Focus';

  @override
  String get setGoalsTitle => 'Tes 3 objectifs du jour';

  @override
  String goalHint(Object index) {
    return 'Objectif $index';
  }

  @override
  String get cyclesHint => 'Cycles';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Sauvegarder';

  @override
  String get defineGoals => 'Définir mes objectifs';

  @override
  String get emptyGoals => 'Définis tes 3 objectifs pour commencer';

  @override
  String get editGoalTitle => 'Modifier cet objectif';

  @override
  String get newGoalHint => 'Nouvel objectif';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteGoalConfirmTitle => 'Supprimer cet objectif ?';

  @override
  String get deleteGoalConfirmBody =>
      'Cette action efface l\'objectif et remet son compteur à zéro.';

  @override
  String get focusTitle => 'Focus';

  @override
  String get focusMode => 'Mode Zen · Respire et avance';

  @override
  String get pausedMode => 'Pause · Reviens quand tu es prêt';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Reprendre';

  @override
  String get finish => 'Terminer';

  @override
  String get rewardTitle => 'Focus terminé !';

  @override
  String get rewardXp => '+120 Flow XP';

  @override
  String get debriefTitle => 'Débrief vocal';

  @override
  String get debriefSubtitle =>
      'Dis-moi en quelques mots comment ça s’est passé.';

  @override
  String get record => 'Enregistrer (10s)';

  @override
  String get stop => 'Stop';

  @override
  String get insightTitle => 'Insight IA';

  @override
  String get backToDashboard => 'Retour au dashboard';

  @override
  String get statsTitle => 'Statistiques & Historique';

  @override
  String get lastSessions => 'Dernières Sessions';

  @override
  String get sessionsLabel => 'Sessions';

  @override
  String get minutesLabel => 'Minutes';

  @override
  String get streakLabel => 'Série';

  @override
  String get weeklyActivity => 'Activité 7 derniers jours';

  @override
  String get noSessions => 'Aucune session terminée pour le moment.';

  @override
  String get completed => 'Terminé';

  @override
  String get inProgress => 'En cours';

  @override
  String sessionsCount(Object done, Object total) {
    return '$done/$total sessions';
  }

  @override
  String get focusCompleteTitle => 'Focus terminé 🎉';

  @override
  String focusCompleteBody(Object goal) {
    return 'Bravo ! Tu as terminé \"$goal\". Passe à la prochaine victoire.';
  }

  @override
  String get trackBlockTitle => 'Parcours actif';

  @override
  String get trackNone => 'Aucun parcours actif';

  @override
  String get trackActivate => 'Activer';

  @override
  String get trackDeactivate => 'Arrêter';

  @override
  String get trackDaily => 'Aujourd\'hui';

  @override
  String get trackAdvance => 'Valider';

  @override
  String get trackUseAsGoal => 'Utiliser comme Objectif 1';

  @override
  String get trackDialogTitle => 'Activer un parcours';

  @override
  String get trackNameHint => 'Nom du livre ou formation';

  @override
  String get trackTypeReading => 'Lecture';

  @override
  String get trackTypeSoft => 'Soft skill';

  @override
  String get trackTypeHard => 'Hard skill';

  @override
  String get trackTotalHint => 'Jours';

  @override
  String get homeStreak => 'Série';

  @override
  String get habitsTitle => 'Habitudes';

  @override
  String get projectsTitle => 'Projets';

  @override
  String get addHabit => 'Ajouter une habitude';

  @override
  String get addProject => 'Ajouter un projet';

  @override
  String get emptyHabits => 'Aucune habitude';

  @override
  String get emptyProjects => 'Aucun projet';
}
