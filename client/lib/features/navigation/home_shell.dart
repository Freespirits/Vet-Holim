import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vet_holim_client/l10n/app_localizations.dart';
import '../patients/patient_card_screen.dart';
import '../encounters/encounters_screen.dart';
import '../meds/meds_screen.dart';
import '../tasks/tasks_screen.dart';
import '../settings/settings_screen.dart';
import '../../config/environment.dart';
import '../../responsive.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.environment});

  final Environment environment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final localizations = AppLocalizations.of(context)!;
    final destinations = _destinations(localizations);
    void selectIndex(int index) {
      ref.read(navigationIndexProvider.notifier).state = index;
    }

    return ResponsiveLayout(
      builder: (context, sizeClass) {
        final useRail = sizeClass != DeviceSizeClass.compact;
        return Scaffold(
          body: Row(
            children: [
              if (useRail)
                _NavigationRailMenu(
                  currentIndex: currentIndex,
                  destinations: destinations,
                  onDestinationSelected: selectIndex,
                ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: _buildPage(currentIndex)),
                    if (!useRail)
                      _BottomNavigationMenu(
                        currentIndex: currentIndex,
                        destinations: destinations,
                        onDestinationSelected: selectIndex,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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

class _NavigationRailMenu extends StatelessWidget {
  const _NavigationRailMenu({
    required this.currentIndex,
    required this.destinations,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final List<NavigationDestination> destinations;
  final void Function(int index) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: currentIndex,
      labelType: NavigationRailLabelType.selected,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations
          .map(
            (destination) => NavigationRailDestination(
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
              label: Text(destination.label),
            ),
          )
          .toList(),
    );
  }
}

class _BottomNavigationMenu extends StatelessWidget {
  const _BottomNavigationMenu({
    required this.currentIndex,
    required this.destinations,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final List<NavigationDestination> destinations;
  final void Function(int index) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations,
    );
  }
}
