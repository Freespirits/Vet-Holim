import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vet_holim_client/app.dart';

void main() {
  testWidgets('renders patient card sections', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(const ProviderScope(child: VetHolimApp()));

    expect(find.text('נתוני מטופל'), findsOneWidget);
    expect(find.text('היסטוריה רפואית'), findsOneWidget);
    expect(find.text('מדדים בסיסיים'), findsOneWidget);
    expect(find.text('יומן טיפולים'), findsOneWidget);
    expect(find.text('אישורים ובדיקות בטיחות'), findsOneWidget);
  });
});
