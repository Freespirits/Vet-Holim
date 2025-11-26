import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_he.dart';

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
    Locale('en'),
    Locale('he')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'וט-חולים'**
  String get appTitle;

  /// No description provided for @patientsTab.
  ///
  /// In en, this message translates to:
  /// **'מטופלים'**
  String get patientsTab;

  /// No description provided for @encountersTab.
  ///
  /// In en, this message translates to:
  /// **'ביקורים'**
  String get encountersTab;

  /// No description provided for @medsTab.
  ///
  /// In en, this message translates to:
  /// **'תרופות'**
  String get medsTab;

  /// No description provided for @tasksTab.
  ///
  /// In en, this message translates to:
  /// **'משימות'**
  String get tasksTab;

  /// No description provided for @settingsTab.
  ///
  /// In en, this message translates to:
  /// **'הגדרות'**
  String get settingsTab;

  /// No description provided for @patientCardTitle.
  ///
  /// In en, this message translates to:
  /// **'כרטיס מטופל'**
  String get patientCardTitle;

  /// No description provided for @patientDemographicsHeading.
  ///
  /// In en, this message translates to:
  /// **'נתוני מטופל'**
  String get patientDemographicsHeading;

  /// No description provided for @medicalHistoryHeading.
  ///
  /// In en, this message translates to:
  /// **'היסטוריה רפואית'**
  String get medicalHistoryHeading;

  /// No description provided for @baselineVitalsHeading.
  ///
  /// In en, this message translates to:
  /// **'מדדים בסיסיים'**
  String get baselineVitalsHeading;

  /// No description provided for @treatmentLogHeading.
  ///
  /// In en, this message translates to:
  /// **'יומן טיפולים'**
  String get treatmentLogHeading;

  /// No description provided for @signoffHeading.
  ///
  /// In en, this message translates to:
  /// **'אישורים ובדיקות בטיחות'**
  String get signoffHeading;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'שם'**
  String get nameLabel;

  /// No description provided for @speciesLabel.
  ///
  /// In en, this message translates to:
  /// **'מין'**
  String get speciesLabel;

  /// No description provided for @breedLabel.
  ///
  /// In en, this message translates to:
  /// **'גזע'**
  String get breedLabel;

  /// No description provided for @sexLabel.
  ///
  /// In en, this message translates to:
  /// **'מין ביולוגי'**
  String get sexLabel;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'גיל'**
  String get ageLabel;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'משקל'**
  String get weightLabel;

  /// No description provided for @coatColorLabel.
  ///
  /// In en, this message translates to:
  /// **'צבע פרווה'**
  String get coatColorLabel;

  /// No description provided for @vaccinationsLabel.
  ///
  /// In en, this message translates to:
  /// **'חיסונים'**
  String get vaccinationsLabel;

  /// No description provided for @allergiesLabel.
  ///
  /// In en, this message translates to:
  /// **'אלרגיות'**
  String get allergiesLabel;

  /// No description provided for @dietLabel.
  ///
  /// In en, this message translates to:
  /// **'תזונה'**
  String get dietLabel;

  /// No description provided for @kidneyIssuesLabel.
  ///
  /// In en, this message translates to:
  /// **'בעיות כליה'**
  String get kidneyIssuesLabel;

  /// No description provided for @vitalsWeight.
  ///
  /// In en, this message translates to:
  /// **'משקל'**
  String get vitalsWeight;

  /// No description provided for @vitalsBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'לחץ דם'**
  String get vitalsBloodPressure;

  /// No description provided for @vitalsPulse.
  ///
  /// In en, this message translates to:
  /// **'דופק'**
  String get vitalsPulse;

  /// No description provided for @vitalsTemperature.
  ///
  /// In en, this message translates to:
  /// **'חום גוף'**
  String get vitalsTemperature;

  /// No description provided for @timestampHeading.
  ///
  /// In en, this message translates to:
  /// **'חותמת זמן'**
  String get timestampHeading;

  /// No description provided for @treatmentHeading.
  ///
  /// In en, this message translates to:
  /// **'טיפול'**
  String get treatmentHeading;

  /// No description provided for @notesHeading.
  ///
  /// In en, this message translates to:
  /// **'מינון / הערות'**
  String get notesHeading;

  /// No description provided for @staffHeading.
  ///
  /// In en, this message translates to:
  /// **'צוות'**
  String get staffHeading;

  /// No description provided for @controlledHeading.
  ///
  /// In en, this message translates to:
  /// **'תרופה מבוקרת'**
  String get controlledHeading;

  /// No description provided for @approvalHeading.
  ///
  /// In en, this message translates to:
  /// **'אישור וטרינר'**
  String get approvalHeading;

  /// No description provided for @checklistMeds.
  ///
  /// In en, this message translates to:
  /// **'תרופות נבדקו והמינונים אומתו'**
  String get checklistMeds;

  /// No description provided for @checklistConsent.
  ///
  /// In en, this message translates to:
  /// **'הסכמת בעלים מתועדת'**
  String get checklistConsent;

  /// No description provided for @checklistControlled.
  ///
  /// In en, this message translates to:
  /// **'תרופה מבוקרת ניתנה — דורש אישור וטרינר'**
  String get checklistControlled;

  /// No description provided for @checklistVetApproval.
  ///
  /// In en, this message translates to:
  /// **'אישור וטרינר תועד לתרופות מבוקרות'**
  String get checklistVetApproval;

  /// No description provided for @checklistDischarge.
  ///
  /// In en, this message translates to:
  /// **'הוראות שחרור נמסרו'**
  String get checklistDischarge;

  /// No description provided for @encountersPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'יומן ביקורים יתווסף בקרוב.'**
  String get encountersPlaceholder;

  /// No description provided for @medsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'מסך תרופות יתווסף בקרוב.'**
  String get medsPlaceholder;

  /// No description provided for @tasksPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'מסך משימות יתווסף בקרוב.'**
  String get tasksPlaceholder;

  /// No description provided for @settingsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'הגדר ברירות מחדל למרפאה.'**
  String get settingsPlaceholder;

  /// No description provided for @patientOverview.
  ///
  /// In en, this message translates to:
  /// **'סקירת מטופל'**
  String get patientOverview;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'היסטוריה'**
  String get history;

  /// No description provided for @vitals.
  ///
  /// In en, this message translates to:
  /// **'מדדים'**
  String get vitals;

  /// No description provided for @treatments.
  ///
  /// In en, this message translates to:
  /// **'טיפולים'**
  String get treatments;

  /// No description provided for @signoffs.
  ///
  /// In en, this message translates to:
  /// **'אישורים'**
  String get signoffs;

  /// No description provided for @treatmentControlledYes.
  ///
  /// In en, this message translates to:
  /// **'כן'**
  String get treatmentControlledYes;

  /// No description provided for @treatmentControlledNo.
  ///
  /// In en, this message translates to:
  /// **'לא'**
  String get treatmentControlledNo;

  /// No description provided for @tasksBoardTitle.
  ///
  /// In en, this message translates to:
  /// **'לוח משימות לדוגמה'**
  String get tasksBoardTitle;

  /// No description provided for @tasksSummaryToday.
  ///
  /// In en, this message translates to:
  /// **'להיום'**
  String get tasksSummaryToday;

  /// No description provided for @tasksSummaryOverdue.
  ///
  /// In en, this message translates to:
  /// **'באיחור'**
  String get tasksSummaryOverdue;

  /// No description provided for @tasksSummaryCompleted.
  ///
  /// In en, this message translates to:
  /// **'הושלמו'**
  String get tasksSummaryCompleted;

  /// No description provided for @tasksSummaryApprovals.
  ///
  /// In en, this message translates to:
  /// **'ממתין לאישור'**
  String get tasksSummaryApprovals;

  /// No description provided for @tasksFilterHeading.
  ///
  /// In en, this message translates to:
  /// **'מסננים'**
  String get tasksFilterHeading;

  /// No description provided for @tasksFilterMedication.
  ///
  /// In en, this message translates to:
  /// **'תרופות'**
  String get tasksFilterMedication;

  /// No description provided for @tasksFilterDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'בדיקות'**
  String get tasksFilterDiagnostics;

  /// No description provided for @tasksFilterNursing.
  ///
  /// In en, this message translates to:
  /// **'סיעוד'**
  String get tasksFilterNursing;

  /// No description provided for @tasksFilterDischarge.
  ///
  /// In en, this message translates to:
  /// **'שחרור'**
  String get tasksFilterDischarge;

  /// No description provided for @tasksQueueHeading.
  ///
  /// In en, this message translates to:
  /// **'תור משימות'**
  String get tasksQueueHeading;

  /// No description provided for @tasksCardPatientLabel.
  ///
  /// In en, this message translates to:
  /// **'מטופל'**
  String get tasksCardPatientLabel;

  /// No description provided for @tasksCardAssigneeLabel.
  ///
  /// In en, this message translates to:
  /// **'אחראי'**
  String get tasksCardAssigneeLabel;

  /// No description provided for @tasksCardDueLabel.
  ///
  /// In en, this message translates to:
  /// **'יעד'**
  String get tasksCardDueLabel;

  /// No description provided for @tasksCardPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'עדיפות גבוהה'**
  String get tasksCardPriorityHigh;

  /// No description provided for @tasksCardPriorityRoutine.
  ///
  /// In en, this message translates to:
  /// **'שגרתי'**
  String get tasksCardPriorityRoutine;

  /// No description provided for @tasksCardRequiresApproval.
  ///
  /// In en, this message translates to:
  /// **'דורש אישור וטרינר'**
  String get tasksCardRequiresApproval;

  /// No description provided for @tasksCardReadyDischarge.
  ///
  /// In en, this message translates to:
  /// **'מוכן לשחרור'**
  String get tasksCardReadyDischarge;

  /// No description provided for @tasksCardMedAction.
  ///
  /// In en, this message translates to:
  /// **'תרופה'**
  String get tasksCardMedAction;

  /// No description provided for @tasksCardImagingAction.
  ///
  /// In en, this message translates to:
  /// **'הדמיה'**
  String get tasksCardImagingAction;

  /// No description provided for @tasksCardNursingAction.
  ///
  /// In en, this message translates to:
  /// **'סיעוד'**
  String get tasksCardNursingAction;

  /// No description provided for @tasksCardDiagnosticsAction.
  ///
  /// In en, this message translates to:
  /// **'אבחון'**
  String get tasksCardDiagnosticsAction;

  /// No description provided for @settingsEnvironmentLabel.
  ///
  /// In en, this message translates to:
  /// **'סביבת הרצה: {environmentName}'**
  String settingsEnvironmentLabel(Object environmentName);

  /// No description provided for @settingsApiLabel.
  ///
  /// In en, this message translates to:
  /// **'כתובת שירות: {apiBaseUrl}'**
  String settingsApiLabel(Object apiBaseUrl);

  /// No description provided for @settingsAuditEnabledLabel.
  ///
  /// In en, this message translates to:
  /// **'יומן ביקורת פעיל: {auditStatus}'**
  String settingsAuditEnabledLabel(Object auditStatus);
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
      <String>['en', 'he'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'he':
      return AppLocalizationsHe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
