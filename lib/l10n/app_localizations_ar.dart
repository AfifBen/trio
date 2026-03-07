// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'تريو';

  @override
  String get homeTagline => '٣ أهداف. تركيز واحد. يوم ناجح.';

  @override
  String get start => 'ابدأ';

  @override
  String get openDashboard => 'فتح لوحة التحكم';

  @override
  String get dashboardTitle => 'تريو — إنجازاتك الثلاثة';

  @override
  String get chooseGoal => 'اختر هدفًا وابدأ التركيز';

  @override
  String get startFocus => 'ابدأ تركيزًا';

  @override
  String get setGoalsTitle => 'أهدافك الثلاثة لليوم';

  @override
  String goalHint(Object index) {
    return 'الهدف $index';
  }

  @override
  String get cyclesHint => 'الدورات';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get defineGoals => 'عرّف أهدافي';

  @override
  String get emptyGoals => 'عرّف أهدافك الثلاثة للبدء';

  @override
  String get editGoalTitle => 'تعديل هذا الهدف';

  @override
  String get newGoalHint => 'هدف جديد';

  @override
  String get delete => 'حذف';

  @override
  String get deleteGoalConfirmTitle => 'حذف هذا الهدف؟';

  @override
  String get deleteGoalConfirmBody => 'سيتم مسح الهدف وإعادة عداداته.';

  @override
  String get focusTitle => 'تركيز';

  @override
  String get focusMode => 'وضع هادئ · تنفّس وتقدّم';

  @override
  String get pausedMode => 'متوقف مؤقتًا · عد عندما تكون جاهزًا';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get resume => 'متابعة';

  @override
  String get finish => 'إنهاء';

  @override
  String get rewardTitle => 'اكتمل التركيز!';

  @override
  String get rewardXp => '+120 نقاط التدفق';

  @override
  String get debriefTitle => 'تفريغ صوتي';

  @override
  String get debriefSubtitle => 'قل باختصار كيف كانت التجربة.';

  @override
  String get record => 'تسجيل (10ث)';

  @override
  String get stop => 'إيقاف';

  @override
  String get insightTitle => 'رؤية الذكاء الاصطناعي';

  @override
  String get backToDashboard => 'العودة إلى اللوحة';

  @override
  String get statsTitle => 'الإحصائيات والسجل';

  @override
  String get lastSessions => 'آخر الجلسات';

  @override
  String get sessionsLabel => 'جلسات';

  @override
  String get minutesLabel => 'دقائق';

  @override
  String get streakLabel => 'سلسلة';

  @override
  String get weeklyActivity => 'نشاط 7 أيام';

  @override
  String get noSessions => 'لا توجد جلسات مكتملة بعد.';

  @override
  String get completed => 'مكتمل';

  @override
  String get inProgress => 'قيد التقدم';

  @override
  String sessionsCount(Object done, Object total) {
    return '$done/$total جلسات';
  }

  @override
  String get focusCompleteTitle => 'اكتمل التركيز 🎉';

  @override
  String focusCompleteBody(Object goal) {
    return 'عمل رائع! أنهيت \"$goal\". انتقل إلى الإنجاز التالي.';
  }

  @override
  String get trackBlockTitle => 'المسار النشط';

  @override
  String get trackNone => 'لا يوجد مسار نشط';

  @override
  String get trackActivate => 'تفعيل';

  @override
  String get trackDeactivate => 'إيقاف المسار';

  @override
  String get trackDaily => 'اليوم';

  @override
  String get trackAdvance => 'تم';

  @override
  String get trackUseAsGoal => 'استخدمه كهدف 1';

  @override
  String get trackDialogTitle => 'تفعيل مسار';

  @override
  String get trackNameHint => 'اسم الكتاب أو الدورة';

  @override
  String get trackTypeReading => 'قراءة';

  @override
  String get trackTypeSoft => 'مهارة ناعمة';

  @override
  String get trackTypeHard => 'مهارة تقنية';

  @override
  String get trackTotalHint => 'أيام';

  @override
  String get homeStreak => 'سلسلة';

  @override
  String get habitsTitle => 'عادات';

  @override
  String get projectsTitle => 'مشاريع';

  @override
  String get addHabit => 'أضف عادة';

  @override
  String get addProject => 'أضف مشروعًا';

  @override
  String get emptyHabits => 'لا توجد عادات بعد';

  @override
  String get emptyProjects => 'لا توجد مشاريع بعد';
}
