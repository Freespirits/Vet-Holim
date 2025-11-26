import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vet_holim_client/l10n/app_localizations.dart';

class PatientProfile {
  const PatientProfile({
    required this.name,
    required this.species,
    required this.breed,
    required this.sex,
    required this.age,
    required this.weight,
    required this.coatColor,
    required this.history,
    required this.vitals,
    required this.treatments,
  });

  final String name;
  final String species;
  final String breed;
  final String sex;
  final String age;
  final String weight;
  final String coatColor;
  final Map<String, String> history;
  final Map<String, String> vitals;
  final List<PatientTreatment> treatments;
}

class PatientTreatment {
  const PatientTreatment({
    required this.timestamp,
    required this.treatment,
    required this.notes,
    required this.staff,
    required this.controlled,
    required this.approved,
  });

  final String timestamp;
  final String treatment;
  final String notes;
  final String staff;
  final bool controlled;
  final bool approved;
}

class PatientCardScreen extends StatelessWidget {
  const PatientCardScreen({super.key});

  PatientProfile _mockProfile() {
    return const PatientProfile(
      name: 'מיצי',
      species: 'חתול',
      breed: 'מעורב סיאמי',
      sex: 'נקבה מעוקרת',
      age: '6 שנים',
      weight: '4.1 ק"ג',
      coatColor: 'סיל פוינט',
      history: const {
        'vaccinations': 'כלבת (2023), FVRCP (2024)',
        'allergies': 'פניצילין (פריחה)',
        'diet': 'דיאטה רפואית לכליות',
        'kidney': 'מחלת כליות כרונית דרגה 2, במעקב חודשי',
      },
      vitals: const {
        'weight': '4.1 ק"ג',
        'bloodPressure': '140/85 מ"מ כספית',
        'pulse': '128 פעימות לדקה (אופציונלי)',
        'temperature': '38.2 מעלות צלזיוס (אופציונלי)',
      },
      treatments: const [
        PatientTreatment(
          timestamp: '2024-07-10 09:00',
          treatment: 'נוזלים תת-עוריים',
          notes: "100 מ\"ל Lactated Ringer's",
          staff: 'אחות דנה',
          controlled: false,
          approved: false,
        ),
        PatientTreatment(
          timestamp: '2024-07-10 11:30',
          treatment: 'בופרנורפין',
          notes: '0.02 מ"ג/ק"ג בזריקה תוך־שרירית',
          staff: 'ד"ר אמיר',
          controlled: true,
          approved: true,
        ),
        PatientTreatment(
          timestamp: '2024-07-10 14:15',
          treatment: 'מרופיטנט',
          notes: '1 מ"ג/ק"ג בהזרקה תת־עורית',
          staff: 'אחות דנה',
          controlled: false,
          approved: false,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final patient = _mockProfile();

    return Stack(
      children: [
        const _PawBackdrop(),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 22,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _PatientHeader(patient: patient),
                          const SizedBox(height: 12),
                          _SectionCard(
                            title: localizations.patientDemographicsHeading,
                            child: _DemographicsGrid(patient: patient, localizations: localizations),
                          ),
                          _SectionCard(
                            title: localizations.medicalHistoryHeading,
                            child: _HistoryList(patient: patient, localizations: localizations),
                          ),
                          _SectionCard(
                            title: localizations.baselineVitalsHeading,
                            child: _VitalsGrid(vitals: patient.vitals, localizations: localizations),
                          ),
                          _SectionCard(
                            title: localizations.treatmentLogHeading,
                            child: _TreatmentTable(
                              treatments: patient.treatments,
                              localizations: localizations,
                            ),
                          ),
                          _SectionCard(
                            title: localizations.signoffHeading,
                            child: _Checklist(localizations: localizations),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PawBackdrop extends StatelessWidget {
  const _PawBackdrop();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF64B5F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Stack(
        children: [
          _PawGraphic(top: -10, left: 12, size: 140, opacity: 0.08, rotationTurns: 0.05),
          _PawGraphic(top: 120, right: 40, size: 110, opacity: 0.07, rotationTurns: -0.03),
          _PawGraphic(bottom: 180, left: 60, size: 120, opacity: 0.05, rotationTurns: 0.12),
          _PawGraphic(bottom: 40, right: -6, size: 150, opacity: 0.06, rotationTurns: -0.08),
          _PawGraphic(top: 260, left: 180, size: 90, opacity: 0.05, rotationTurns: 0.18),
        ],
      ),
    );
  }
}

class _PawGraphic extends StatelessWidget {
  const _PawGraphic({
    required this.size,
    required this.opacity,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.rotationTurns = 0,
  });

  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final double size;
  final double opacity;
  final double rotationTurns;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Transform.rotate(
        angle: rotationTurns * 2 * math.pi,
        child: Icon(
          Icons.pets,
          size: size,
          color: Colors.white.withOpacity(opacity),
        ),
      ),
    );
  }
}

class _PatientHeader extends StatelessWidget {
  const _PatientHeader({required this.patient});

  final PatientProfile patient;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accentColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(Icons.pets, color: accentColor, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.badge_outlined, size: 18, color: accentColor),
                    const SizedBox(width: 6),
                    Text(
                      patient.species,
                      style: textTheme.bodyMedium?.copyWith(color: Colors.black87),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.calendar_today_outlined, size: 18, color: accentColor),
                    const SizedBox(width: 6),
                    Text(patient.age, style: textTheme.bodyMedium?.copyWith(color: Colors.black87)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.04),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _DemographicsGrid extends StatelessWidget {
  const _DemographicsGrid({required this.patient, required this.localizations});

  final PatientProfile patient;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final entries = <(String, String)>[
      (localizations.nameLabel, patient.name),
      (localizations.speciesLabel, patient.species),
      (localizations.breedLabel, patient.breed),
      (localizations.sexLabel, patient.sex),
      (localizations.ageLabel, patient.age),
      (localizations.weightLabel, patient.weight),
      (localizations.coatColorLabel, patient.coatColor),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width > 900
            ? 3
            : width > 600
                ? 2
                : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 3.6,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final (label, value) = entries[index];
            return _LabeledValue(label: label, value: value);
          },
        );
      },
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.patient, required this.localizations});

  final PatientProfile patient;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final entries = <(String, String)>[
      (localizations.vaccinationsLabel, patient.history['vaccinations'] ?? ''),
      (localizations.allergiesLabel, patient.history['allergies'] ?? ''),
      (localizations.dietLabel, patient.history['diet'] ?? ''),
      (localizations.kidneyIssuesLabel, patient.history['kidney'] ?? ''),
    ];

    return Column(
      children: [
        for (final (label, value) in entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _LabeledValue(label: label, value: value),
          ),
      ],
    );
  }
}

class _VitalsGrid extends StatelessWidget {
  const _VitalsGrid({required this.vitals, required this.localizations});

  final Map<String, String> vitals;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final entries = <(String, String)>[
      (localizations.vitalsWeight, vitals['weight'] ?? ''),
      (localizations.vitalsBloodPressure, vitals['bloodPressure'] ?? ''),
      (localizations.vitalsPulse, vitals['pulse'] ?? ''),
      (localizations.vitalsTemperature, vitals['temperature'] ?? ''),
    ];

    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 8,
      runSpacing: 8,
      children: entries
          .map(
            (entry) => Chip(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              label: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(entry.$1, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(entry.$2, style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _TreatmentTable extends StatelessWidget {
  const _TreatmentTable({required this.treatments, required this.localizations});

  final List<PatientTreatment> treatments;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text(localizations.timestampHeading)),
          DataColumn(label: Text(localizations.treatmentHeading)),
          DataColumn(label: Text(localizations.notesHeading)),
          DataColumn(label: Text(localizations.staffHeading)),
          DataColumn(label: Text(localizations.controlledHeading)),
          DataColumn(label: Text(localizations.approvalHeading)),
        ],
        rows: treatments
            .map(
              (entry) => DataRow(
                cells: [
                  DataCell(Text(entry.timestamp, textDirection: TextDirection.ltr)),
                  DataCell(Text(entry.treatment)),
                  DataCell(Text(entry.notes, textDirection: TextDirection.ltr)),
                  DataCell(Text(entry.staff)),
                  DataCell(Text(entry.controlled
                      ? localizations.treatmentControlledYes
                      : localizations.treatmentControlledNo)),
                  DataCell(Text(entry.approved
                      ? localizations.treatmentControlledYes
                      : '—')),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Checklist extends StatelessWidget {
  const _Checklist({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final entries = [
      localizations.checklistMeds,
      localizations.checklistConsent,
      localizations.checklistControlled,
      localizations.checklistVetApproval,
      localizations.checklistDischarge,
    ];

    return Column(
      children: [
        for (final label in entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Checkbox(value: false, onChanged: (_) {}),
                Expanded(child: Text(label)),
              ],
            ),
          )
      ],
    );
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outlineVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 0,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textDirection: TextDirection.rtl,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.left,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
