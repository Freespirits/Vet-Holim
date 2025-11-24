import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../patients/patient_card_screen.dart';
import '../encounters/encounters_screen.dart';
import '../meds/meds_screen.dart';
import '../tasks/tasks_screen.dart';
import '../settings/settings_screen.dart';
import '../../config/environment.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.environment});

  final Environment environment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final localizations = AppLocalizations.of(context)!;
    final destinations = _destinations(localizations);
    final width = MediaQuery.of(context).size.width;
    final useRail = width >= 900;

    return Scaffold(
      body: Row(
        children: [
          if (useRail)
            NavigationRail(
              selectedIndex: currentIndex,
              labelType: NavigationRailLabelType.selected,
              onDestinationSelected: (index) =>
                  ref.read(navigationIndexProvider.notifier).state = index,
              destinations: destinations
                  .map(
                    (destination) => NavigationRailDestination(
                      icon: destination.icon,
                      selectedIcon: destination.selectedIcon,
                      label: Text(destination.label),
                    ),
                  )
                  .toList(),
            ),
          Expanded(
            child: Column(
              children: [
                Expanded(child: _buildPage(currentIndex)),
                if (!useRail)
                  NavigationBar(
                    selectedIndex: currentIndex,
                    onDestinationSelected: (index) => ref
                        .read(navigationIndexProvider.notifier)
                        .state = index,
                    destinations: destinations,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<NavigationDestination> _destinations(AppLocalizations localizations) {
    return [
      NavigationDestination(
        icon: const Icon(Icons.pets_outlined),
        selectedIcon: const Icon(Icons.pets),
        label: localizations.patientsTab,
      ),
      NavigationDestination(
        icon: const Icon(Icons.event_note_outlined),
        selectedIcon: const Icon(Icons.event_note),
        label: localizations.encountersTab,
      ),
      NavigationDestination(
        icon: const Icon(Icons.medication_outlined),
        selectedIcon: const Icon(Icons.medication),
        label: localizations.medsTab,
      ),
      NavigationDestination(
        icon: const Icon(Icons.checklist_outlined),
        selectedIcon: const Icon(Icons.checklist),
        label: localizations.tasksTab,
      ),
      NavigationDestination(
        icon: const Icon(Icons.settings_outlined),
        selectedIcon: const Icon(Icons.settings),
        label: localizations.settingsTab,
      ),
    ];
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 1:
        return const EncountersScreen();
      case 2:
        return const MedsScreen();
      case 3:
        return const TasksScreen();
      case 4:
        return SettingsScreen(environment: environment);
      case 0:
      default:
        return const PatientCardScreen();
    }
  }
}
