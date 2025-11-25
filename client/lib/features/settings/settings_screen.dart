import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/environment.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.environment});

  final Environment environment;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final environmentName = switch (environment.name) {
      'production' => 'ייצור',
      'staging' => 'סביבת בדיקות',
      'dev' => 'פיתוח',
      _ => environment.name,
    };
    final auditStatus = environment.featureFlags.enableAuditTrail
        ? localizations.treatmentControlledYes
        : localizations.treatmentControlledNo;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            localizations.settingsPlaceholder,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(localizations
              .settingsEnvironmentLabel(environmentName: environmentName)),
          Text(
            localizations.settingsApiLabel(apiBaseUrl: environment.apiBaseUrl),
            textDirection: TextDirection.ltr,
          ),
          Text(localizations.settingsAuditEnabledLabel(auditStatus: auditStatus)),
        ],
      ),
    );
  }
}
