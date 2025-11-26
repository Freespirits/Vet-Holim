// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'וט-חולים';

  @override
  String get patientsTab => 'מטופלים';

  @override
  String get encountersTab => 'ביקורים';

  @override
  String get medsTab => 'תרופות';

  @override
  String get tasksTab => 'משימות';

  @override
  String get settingsTab => 'הגדרות';

  @override
  String get patientCardTitle => 'כרטיס מטופל';

  @override
  String get patientDemographicsHeading => 'נתוני מטופל';

  @override
  String get medicalHistoryHeading => 'היסטוריה רפואית';

  @override
  String get baselineVitalsHeading => 'מדדים בסיסיים';

  @override
  String get treatmentLogHeading => 'יומן טיפולים';

  @override
  String get signoffHeading => 'אישורים ובדיקות בטיחות';

  @override
  String get nameLabel => 'שם';

  @override
  String get speciesLabel => 'מין';

  @override
  String get breedLabel => 'גזע';

  @override
  String get sexLabel => 'מין ביולוגי';

  @override
  String get ageLabel => 'גיל';

  @override
  String get weightLabel => 'משקל';

  @override
  String get coatColorLabel => 'צבע פרווה';

  @override
  String get vaccinationsLabel => 'חיסונים';

  @override
  String get allergiesLabel => 'אלרגיות';

  @override
  String get dietLabel => 'תזונה';

  @override
  String get kidneyIssuesLabel => 'בעיות כליה';

  @override
  String get vitalsWeight => 'משקל';

  @override
  String get vitalsBloodPressure => 'לחץ דם';

  @override
  String get vitalsPulse => 'דופק';

  @override
  String get vitalsTemperature => 'חום גוף';

  @override
  String get timestampHeading => 'חותמת זמן';

  @override
  String get treatmentHeading => 'טיפול';

  @override
  String get notesHeading => 'מינון / הערות';

  @override
  String get staffHeading => 'צוות';

  @override
  String get controlledHeading => 'תרופה מבוקרת';

  @override
  String get approvalHeading => 'אישור וטרינר';

  @override
  String get checklistMeds => 'תרופות נבדקו והמינונים אומתו';

  @override
  String get checklistConsent => 'הסכמת בעלים מתועדת';

  @override
  String get checklistControlled => 'תרופה מבוקרת ניתנה — דורש אישור וטרינר';

  @override
  String get checklistVetApproval => 'אישור וטרינר תועד לתרופות מבוקרות';

  @override
  String get checklistDischarge => 'הוראות שחרור נמסרו';

  @override
  String get encountersPlaceholder => 'יומן ביקורים יתווסף בקרוב.';

  @override
  String get medsPlaceholder => 'מסך תרופות יתווסף בקרוב.';

  @override
  String get tasksPlaceholder => 'מסך משימות יתווסף בקרוב.';

  @override
  String get settingsPlaceholder => 'הגדר ברירות מחדל למרפאה.';

  @override
  String get patientOverview => 'סקירת מטופל';

  @override
  String get history => 'היסטוריה';

  @override
  String get vitals => 'מדדים';

  @override
  String get treatments => 'טיפולים';

  @override
  String get signoffs => 'אישורים';

  @override
  String get treatmentControlledYes => 'כן';

  @override
  String get treatmentControlledNo => 'לא';

  @override
  String get tasksBoardTitle => 'לוח משימות לדוגמה';

  @override
  String get tasksSummaryToday => 'להיום';

  @override
  String get tasksSummaryOverdue => 'באיחור';

  @override
  String get tasksSummaryCompleted => 'הושלמו';

  @override
  String get tasksSummaryApprovals => 'ממתין לאישור';

  @override
  String get tasksFilterHeading => 'מסננים';

  @override
  String get tasksFilterMedication => 'תרופות';

  @override
  String get tasksFilterDiagnostics => 'בדיקות';

  @override
  String get tasksFilterNursing => 'סיעוד';

  @override
  String get tasksFilterDischarge => 'שחרור';

  @override
  String get tasksQueueHeading => 'תור משימות';

  @override
  String get tasksCardPatientLabel => 'מטופל';

  @override
  String get tasksCardAssigneeLabel => 'אחראי';

  @override
  String get tasksCardDueLabel => 'יעד';

  @override
  String get tasksCardPriorityHigh => 'עדיפות גבוהה';

  @override
  String get tasksCardPriorityRoutine => 'שגרתי';

  @override
  String get tasksCardRequiresApproval => 'דורש אישור וטרינר';

  @override
  String get tasksCardReadyDischarge => 'מוכן לשחרור';

  @override
  String get tasksCardMedAction => 'תרופה';

  @override
  String get tasksCardImagingAction => 'הדמיה';

  @override
  String get tasksCardNursingAction => 'סיעוד';

  @override
  String get tasksCardDiagnosticsAction => 'אבחון';

  @override
  String settingsEnvironmentLabel(Object environmentName) {
    return 'סביבת הרצה: $environmentName';
  }

  @override
  String settingsApiLabel(Object apiBaseUrl) {
    return 'כתובת שירות: $apiBaseUrl';
  }

  @override
  String settingsAuditEnabledLabel(Object auditStatus) {
    return 'יומן ביקורת פעיל: $auditStatus';
  }
}
