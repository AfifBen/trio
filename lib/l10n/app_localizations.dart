import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'TRIO'**
  String get appName;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'3 goals. 1 focus. A winning day.'**
  String get homeTagline;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @openDashboard.
  ///
  /// In en, this message translates to:
  /// **'Open dashboard'**
  String get openDashboard;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'TRIO — Your 3 Wins'**
  String get dashboardTitle;

  /// No description provided for @chooseGoal.
  ///
  /// In en, this message translates to:
  /// **'Choose a goal and start a focus'**
  String get chooseGoal;

  /// No description provided for @startFocus.
  ///
  /// In en, this message translates to:
  /// **'Start a focus'**
  String get startFocus;

  /// No description provided for @setGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your 3 goals for today'**
  String get setGoalsTitle;

  /// No description provided for @goalHint.
  ///
  /// In en, this message translates to:
  /// **'Goal {index}'**
  String goalHint(Object index);

  /// No description provided for @cyclesHint.
  ///
  /// In en, this message translates to:
  /// **'Cycles'**
  String get cyclesHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @defineGoals.
  ///
  /// In en, this message translates to:
  /// **'Define my goals'**
  String get defineGoals;

  /// No description provided for @emptyGoals.
  ///
  /// In en, this message translates to:
  /// **'Define your 3 goals to start'**
  String get emptyGoals;

  /// No description provided for @editGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit this goal'**
  String get editGoalTitle;

  /// No description provided for @newGoalHint.
  ///
  /// In en, this message translates to:
  /// **'New goal'**
  String get newGoalHint;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteGoalConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this goal?'**
  String get deleteGoalConfirmTitle;

  /// No description provided for @deleteGoalConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will clear the goal and reset its counter.'**
  String get deleteGoalConfirmBody;

  /// No description provided for @focusTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focusTitle;

  /// No description provided for @focusMode.
  ///
  /// In en, this message translates to:
  /// **'Zen mode · breathe and move forward'**
  String get focusMode;

  /// No description provided for @pausedMode.
  ///
  /// In en, this message translates to:
  /// **'Paused · come back when ready'**
  String get pausedMode;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @rewardTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus complete!'**
  String get rewardTitle;

  /// No description provided for @rewardXp.
  ///
  /// In en, this message translates to:
  /// **'+120 Flow XP'**
  String get rewardXp;

  /// No description provided for @debriefTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice debrief'**
  String get debriefTitle;

  /// No description provided for @debriefSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell me in a few words how it went.'**
  String get debriefSubtitle;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record (10s)'**
  String get record;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @insightTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Insight'**
  String get insightTitle;

  /// No description provided for @backToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to dashboard'**
  String get backToDashboard;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stats & History'**
  String get statsTitle;

  /// No description provided for @lastSessions.
  ///
  /// In en, this message translates to:
  /// **'Latest Sessions'**
  String get lastSessions;

  /// No description provided for @sessionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsLabel;

  /// No description provided for @minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutesLabel;

  /// No description provided for @streakLabel.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streakLabel;

  /// No description provided for @weeklyActivity.
  ///
  /// In en, this message translates to:
  /// **'7-day activity'**
  String get weeklyActivity;

  /// No description provided for @noSessions.
  ///
  /// In en, this message translates to:
  /// **'No completed sessions yet.'**
  String get noSessions;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @sessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} sessions'**
  String sessionsCount(Object done, Object total);

  /// No description provided for @focusCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus complete 🎉'**
  String get focusCompleteTitle;

  /// No description provided for @focusCompleteBody.
  ///
  /// In en, this message translates to:
  /// **'Great job! You finished \"{goal}\". Move to the next win.'**
  String focusCompleteBody(Object goal);

  /// No description provided for @trackBlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Active path'**
  String get trackBlockTitle;

  /// No description provided for @trackNone.
  ///
  /// In en, this message translates to:
  /// **'No active path'**
  String get trackNone;

  /// No description provided for @trackActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get trackActivate;

  /// No description provided for @trackDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Stop path'**
  String get trackDeactivate;

  /// No description provided for @trackDaily.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get trackDaily;

  /// No description provided for @trackAdvance.
  ///
  /// In en, this message translates to:
  /// **'Mark done'**
  String get trackAdvance;

  /// No description provided for @trackUseAsGoal.
  ///
  /// In en, this message translates to:
  /// **'Use as Goal 1'**
  String get trackUseAsGoal;

  /// No description provided for @trackDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Activate a path'**
  String get trackDialogTitle;

  /// No description provided for @trackNameHint.
  ///
  /// In en, this message translates to:
  /// **'Course or book name'**
  String get trackNameHint;

  /// No description provided for @trackTypeReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get trackTypeReading;

  /// No description provided for @trackTypeSoft.
  ///
  /// In en, this message translates to:
  /// **'Soft skill'**
  String get trackTypeSoft;

  /// No description provided for @trackTypeHard.
  ///
  /// In en, this message translates to:
  /// **'Hard skill'**
  String get trackTypeHard;

  /// No description provided for @trackTotalHint.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get trackTotalHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
