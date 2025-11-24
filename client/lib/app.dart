import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'features/navigation/home_shell.dart';
import 'config/environment.dart';

class VetHolimApp extends StatelessWidget {
  const VetHolimApp({super.key, required this.environment});

  final Environment environment;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
      ),
      locale: const Locale('he'),
      supportedLocales: const [
        Locale('en'),
        Locale('he'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: HomeShell(environment: environment),
      ),
    );
  }
}
