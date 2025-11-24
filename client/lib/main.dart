import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vet_holim_client/app.dart';
import 'package:vet_holim_client/config/environment.dart';

void main() {
  final environment = buildEnvironment();
  runApp(ProviderScope(child: VetHolimApp(environment: environment)));
}
