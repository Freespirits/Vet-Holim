import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vet_holim_client/app.dart';

void main() {
  testWidgets('shows navigation destinations for compact layouts', (tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 800));
    await tester.pumpWidget(const ProviderScope(child: VetHolimApp()));

    expect(find.text('מטופלים'), findsOneWidget);
    expect(find.text('ביקורים'), findsOneWidget);
    expect(find.text('תרופות'), findsOneWidget);
  });

  testWidgets('uses navigation rail on wide layouts', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    await tester.pumpWidget(const ProviderScope(child: VetHolimApp()));

    expect(find.byType(NavigationRail), findsOneWidget);
  });
}
