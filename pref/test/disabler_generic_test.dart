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
  group('PrefDisablerGeneric', () {
    testWidgets('int', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefDisablerGeneric(
                pref: 'test',
                nullValue: 2,
                children: [
                  Placeholder(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(service.get<int>('test'), isNull);
      expect(find.byType(PrefDisablerGeneric<int>), findsOneWidget);
      expect(tester.isDisabled(), false);

      service.set<int>('test', 2);
      await tester.pump();

      expect(find.byType(PrefDisablerGeneric<int>), findsOneWidget);
      expect(tester.isDisabled(), true);

      service.set<int>('test', 3);
      await tester.pump();

      expect(find.byType(PrefDisablerGeneric<int>), findsOneWidget);
      expect(tester.isDisabled(), false);

      service.set<String>('test', 'ON');
      await tester.pump();

      expect(find.byType(PrefDisablerGeneric<int>), findsOneWidget);
      expect(tester.isDisabled(), false);
    });

    testWidgets('int reversed', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefDisablerGeneric(
                pref: 'test',
                nullValue: 3,
                reversed: true,
                children: [
                  Placeholder(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(service.get<int>('test'), isNull);
      expect(find.byType(PrefDisablerGeneric<int>), findsOneWidget);
      expect(tester.isDisabled(), true);

      service.set<int>('test', 3);
      await tester.pump();

      expect(find.byType(PrefDisablerGeneric<int>), findsOneWidget);
      expect(tester.isDisabled(), false);

      service.set<int>('test', 2);
      await tester.pump();

      expect(find.byType(PrefDisablerGeneric<int>), findsOneWidget);
      expect(tester.isDisabled(), true);

      service.set<String>('test', 'ON');
      await tester.pump();

      expect(find.byType(PrefDisablerGeneric<int>), findsOneWidget);
      expect(tester.isDisabled(), true);
    });

    testWidgets('string', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefDisablerGeneric(
                pref: 'test',
                nullValue: 'foo',
                children: [
                  Placeholder(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(service.get<String>('test'), isNull);
      expect(find.byType(PrefDisablerGeneric<String>), findsOneWidget);
      expect(tester.isDisabled(), false);

      service.set<String>('test', 'foo');
      await tester.pump();

      expect(find.byType(PrefDisablerGeneric<String>), findsOneWidget);
      expect(tester.isDisabled(), true);

      service.set<String>('test', 'bar');
      await tester.pump();

      expect(find.byType(PrefDisablerGeneric<String>), findsOneWidget);
      expect(tester.isDisabled(), false);

      service.set<bool>('test', false);
      await tester.pump();

      expect(find.byType(PrefDisablerGeneric<String>), findsOneWidget);
      expect(tester.isDisabled(), false);
    });

    testWidgets('string reversed', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefDisablerGeneric(
                pref: 'test',
                nullValue: 'foo',
                reversed: true,
                children: [
                  Placeholder(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(service.get<String>('test'), isNull);
      expect(find.byType(PrefDisablerGeneric<String>), findsOneWidget);
      expect(tester.isDisabled(), true);

      service.set<String>('test', 'foo');
      await tester.pump();

      expect(find.byType(PrefDisablerGeneric<String>), findsOneWidget);
      expect(tester.isDisabled(), false);

      service.set<String>('test', 'bar');
      await tester.pump();

      expect(find.byType(PrefDisablerGeneric<String>), findsOneWidget);
      expect(tester.isDisabled(), true);

      service.set<bool>('test', true);
      await tester.pump();

      expect(find.byType(PrefDisablerGeneric<String>), findsOneWidget);
      expect(tester.isDisabled(), true);
    });
  });
}
