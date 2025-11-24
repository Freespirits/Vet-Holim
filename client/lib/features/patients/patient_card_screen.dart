import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return PatientProfile(
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
        'kidney': 'CKD דרגה II, במעקב חודשי',
      },
      vitals: const {
        'weight': '4.1 ק"ג',
        'bloodPressure': '140/85 מ"מ כספית',
        'pulse': '128 bpm (אופציונלי)',
        'temperature': '38.2°C (אופציונלי)',
      },
      treatments: const [
        PatientTreatment(
          timestamp: '2024-07-10 09:00',
          treatment: 'נוזלים תת-עוריים',
          notes: "100 mL Lactated Ringer's",
          staff: 'RN Dana',
          controlled: false,
          approved: false,
        ),
        PatientTreatment(
          timestamp: '2024-07-10 11:30',
          treatment: 'בופרנורפין',
          notes: '0.02 מ"ג/ק"ג IM',
          staff: 'Dr. Amir',
          controlled: true,
          approved: true,
        ),
        PatientTreatment(
          timestamp: '2024-07-10 14:15',
          treatment: 'מרופיטנט',
          notes: '1 מ"ג/ק"ג SQ',
          staff: 'RN Dana',
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAFC),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
        final isWide = constraints.maxWidth > 720;
        final crossAxisCount = isWide ? 3 : 2;
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
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          Flexible(
            child: Text(
              value,
              textDirection: TextDirection.ltr,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
