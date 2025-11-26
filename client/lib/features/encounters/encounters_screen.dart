import 'package:flutter/material.dart';
import 'package:vet_holim_client/l10n/app_localizations.dart';

class EncountersScreen extends StatelessWidget {
  const EncountersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: Text(
        localizations.encountersPlaceholder,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
