import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TaskPriority { high, routine }

typedef _StringTag = (String label, bool selected);

class TaskBoardItem {
  const TaskBoardItem({
    required this.title,
    required this.patient,
    required this.assignee,
    required this.dueLabel,
    required this.priority,
    required this.action,
    this.requiresApproval = false,
    this.isDischargeReady = false,
  });

  final String title;
  final String patient;
  final String assignee;
  final String dueLabel;
  final TaskPriority priority;
  final String action;
  final bool requiresApproval;
  final bool isDischargeReady;
}

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  List<TaskBoardItem> _mockTasks(AppLocalizations localizations) {
    return [
      TaskBoardItem(
        title: 'שיכוך כאבים עם Buprenorphine',
        patient: 'מיצי',
        assignee: 'אחות דנה',
        dueLabel: '10:00',
        priority: TaskPriority.high,
        action: localizations.tasksCardMedAction,
        requiresApproval: true,
      ),
      TaskBoardItem(
        title: 'נוזלים תוך־ורידיים — 100 מ"ל Lactated Ringer\'s',
        patient: 'מיצי',
        assignee: 'אחות דנה',
        dueLabel: '10:30',
        priority: TaskPriority.routine,
        action: localizations.tasksCardNursingAction,
      ),
      TaskBoardItem(
        title: 'אולטרסאונד בטן לביקורת',
        patient: 'בוסקו',
        assignee: 'ד"ר אמיר',
        dueLabel: '12:00',
        priority: TaskPriority.high,
        action: localizations.tasksCardImagingAction,
      ),
      TaskBoardItem(
        title: 'ספירת דם מלאה + כימיה בדם',
        patient: 'לוקה',
        assignee: 'טכנאית מעבדה מאיה',
        dueLabel: '12:30',
        priority: TaskPriority.routine,
        action: localizations.tasksCardDiagnosticsAction,
        requiresApproval: true,
      ),
      TaskBoardItem(
        title: 'תדרוך שחרור עם הבעלים',
        patient: 'לוקה',
        assignee: 'אחות דנה',
        dueLabel: '13:15',
        priority: TaskPriority.routine,
        action: localizations.tasksCardNursingAction,
        isDischargeReady: true,
      ),
      TaskBoardItem(
        title: 'Maropitant 1 מ"ג/ק"ג בהזרקה תת־עורית',
        patient: 'מיצי',
        assignee: 'אחות דנה',
        dueLabel: '14:00',
        priority: TaskPriority.routine,
        action: localizations.tasksCardMedAction,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final tasks = _mockTasks(localizations);
    final filters = <_StringTag>[
      (localizations.tasksFilterMedication, true),
      (localizations.tasksFilterDiagnostics, true),
      (localizations.tasksFilterNursing, false),
      (localizations.tasksFilterDischarge, false),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAFC),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                localizations.tasksBoardTitle,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatCard(
                    label: localizations.tasksSummaryToday,
                    value: '6',
                    icon: Icons.calendar_today_outlined,
                    color: const Color(0xFF0EA5E9),
                  ),
                  _StatCard(
                    label: localizations.tasksSummaryOverdue,
                    value: '2',
                    icon: Icons.warning_amber_rounded,
                    color: const Color(0xFFF59E0B),
                  ),
                  _StatCard(
                    label: localizations.tasksSummaryApprovals,
                    value: '3',
                    icon: Icons.medical_services_outlined,
                    color: const Color(0xFF6366F1),
                  ),
                  _StatCard(
                    label: localizations.tasksSummaryCompleted,
                    value: '12',
                    icon: Icons.check_circle_outline,
                    color: const Color(0xFF22C55E),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                localizations.tasksFilterHeading,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final filter in filters)
                    FilterChip(
                      label: Text(filter.$1),
                      selected: filter.$2,
                      showCheckmark: true,
                      onSelected: (_) {},
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                localizations.tasksQueueHeading,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...tasks.map((task) => _TaskCard(task: task, localizations: localizations)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.12),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.black.withOpacity(0.7)),
                  ),
                  Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task, required this.localizations});

  final TaskBoardItem task;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final priorityLabel = task.priority == TaskPriority.high
        ? localizations.tasksCardPriorityHigh
        : localizations.tasksCardPriorityRoutine;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.push_pin_outlined, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _TagChip(
                  label: '${localizations.tasksCardPatientLabel}: ${task.patient}',
                  icon: Icons.pets_outlined,
                  color: colorScheme.secondary,
                ),
                _TagChip(
                  label: '${localizations.tasksCardAssigneeLabel}: ${task.assignee}',
                  icon: Icons.badge_outlined,
                  color: colorScheme.primary,
                ),
                _TagChip(
                  label: '${localizations.tasksCardDueLabel}: ${task.dueLabel}',
                  icon: Icons.schedule,
                  color: colorScheme.tertiary,
                  textDirection: TextDirection.ltr,
                ),
                _TagChip(
                  label: priorityLabel,
                  icon: Icons.flag,
                  color: task.priority == TaskPriority.high
                      ? Colors.redAccent
                      : colorScheme.primary,
                ),
                _TagChip(
                  label: task.action,
                  icon: Icons.assignment,
                  color: colorScheme.secondary,
                ),
                if (task.requiresApproval)
                  _TagChip(
                    label: localizations.tasksCardRequiresApproval,
                    icon: Icons.medical_information_outlined,
                    color: Colors.deepPurple,
                  ),
                if (task.isDischargeReady)
                  _TagChip(
                    label: localizations.tasksCardReadyDischarge,
                    icon: Icons.door_open,
                    color: Colors.teal,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.icon,
    required this.color,
    this.textDirection,
  });

  final String label;
  final IconData icon;
  final Color color;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: color.withOpacity(0.1),
      avatar: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        textDirection: textDirection,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    );
  }
}
