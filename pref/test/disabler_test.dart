// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pref/pref.dart';

extension DisableState on WidgetTester {
  bool isDisabled() {
    return (widget(find.byType(PrefDisableState)) as PrefDisableState).disabled;
  }
}

void main() {
  group('PrefDisabler', () {
    testWidgets('basic', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefDisabler(
                pref: 'test',
                children: [
                  Placeholder(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(service.get<bool>('test'), isNull);
      expect(find.byType(PrefDisabler), findsOneWidget);
      expect(tester.isDisabled(), false);

      service.set<bool>('test', true);
      await tester.pump();

      expect(find.byType(PrefDisabler), findsOneWidget);
      expect(tester.isDisabled(), true);

      service.set<bool>('test', false);
      await tester.pump();

      expect(find.byType(PrefDisabler), findsOneWidget);
      expect(tester.isDisabled(), false);

      service.set<String>('test', 'ON');
      await tester.pump();

      expect(find.byType(PrefDisabler), findsOneWidget);
      expect(tester.isDisabled(), false);
    });

    testWidgets('reversed', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefDisabler(
                pref: 'test',
                reversed: true,
                children: [
                  Placeholder(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(service.get<bool>('test'), isNull);
      expect(find.byType(PrefDisabler), findsOneWidget);
      expect(tester.isDisabled(), true);

      service.set<bool>('test', true);
      await tester.pump();

      expect(find.byType(PrefDisabler), findsOneWidget);
      expect(tester.isDisabled(), false);

      service.set<bool>('test', false);
      await tester.pump();

      expect(find.byType(PrefDisabler), findsOneWidget);
      expect(tester.isDisabled(), true);

      service.set<String>('test', 'ON');
      await tester.pump();

      expect(find.byType(PrefDisabler), findsOneWidget);
      expect(tester.isDisabled(), true);
    });
  });
}
