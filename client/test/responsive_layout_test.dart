import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vet_holim_client/responsive.dart';

void main() {
  group('sizeClassForWidth', () {
    test('returns compact for widths below 600', () {
      expect(sizeClassForWidth(500), DeviceSizeClass.compact);
    });

    test('returns medium for widths between 600 and 839', () {
      expect(sizeClassForWidth(700), DeviceSizeClass.medium);
    });

    test('returns expanded for widths 840 and above', () {
      expect(sizeClassForWidth(1000), DeviceSizeClass.expanded);
    });
  });

  testWidgets('passes size class to builder based on constraints',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(700, 900));

    await tester.pumpWidget(
      MaterialApp(
        home: ResponsiveLayout(
          builder: (context, sizeClass) => Text(sizeClass.name),
        ),
      ),
    );

    expect(find.text('medium'), findsOneWidget);
  });

  testWidgets('identifies phones and tablets via helpers', (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            final phoneCheck = ResponsiveLayout.isPhone(context);
            final tabletCheck = ResponsiveLayout.isTablet(context);
            return Column(
              children: [
                Text('isPhone:$phoneCheck'),
                Text('isTablet:$tabletCheck'),
              ],
            );
          },
        ),
      ),
    );

    expect(find.text('isPhone:true'), findsOneWidget);
    expect(find.text('isTablet:false'), findsOneWidget);

    await tester.binding.setSurfaceSize(const Size(1000, 900));
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            final phoneCheck = ResponsiveLayout.isPhone(context);
            final tabletCheck = ResponsiveLayout.isTablet(context);
            return Column(
              children: [
                Text('isPhone:$phoneCheck'),
                Text('isTablet:$tabletCheck'),
              ],
            );
          },
        ),
      ),
    );

    expect(find.text('isPhone:false'), findsOneWidget);
    expect(find.text('isTablet:true'), findsOneWidget);
  });
}
