import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/environment.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.environment});

  final Environment environment;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            localizations.settingsPlaceholder,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text('Environment: ${environment.name}'),
          Text('API: ${environment.apiBaseUrl}'),
          Text('Audit enabled: ${environment.featureFlags.enableAuditTrail}'),
        ],
      ),
    );
  }
}
