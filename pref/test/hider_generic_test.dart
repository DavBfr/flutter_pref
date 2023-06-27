// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pref/pref.dart';

void main() {
  group('PrefHiderGeneric', () {
    testWidgets('int', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefHiderGeneric(
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
      expect(find.byType(PrefHiderGeneric<int>), findsOneWidget);
      expect(find.byType(Placeholder), findsOneWidget);

      service.set<int>('test', 2);
      await tester.pump();

      expect(find.byType(PrefHiderGeneric<int>), findsOneWidget);
      expect(find.byType(Placeholder), findsNothing);

      service.set<int>('test', 3);
      await tester.pump();

      expect(find.byType(PrefHiderGeneric<int>), findsOneWidget);
      expect(find.byType(Placeholder), findsOneWidget);

      service.set<String>('test', 'ON');
      await tester.pump();

      expect(find.byType(PrefHiderGeneric<int>), findsOneWidget);
      expect(find.byType(Placeholder), findsOneWidget);
    });

    testWidgets('int reversed', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefHiderGeneric(
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
      expect(find.byType(PrefHiderGeneric<int>), findsOneWidget);
      expect(find.byType(Placeholder), findsNothing);

      service.set<int>('test', 3);
      await tester.pump();

      expect(find.byType(PrefHiderGeneric<int>), findsOneWidget);
      expect(find.byType(Placeholder), findsOneWidget);

      service.set<int>('test', 2);
      await tester.pump();

      expect(find.byType(PrefHiderGeneric<int>), findsOneWidget);
      expect(find.byType(Placeholder), findsNothing);

      service.set<String>('test', 'ON');
      await tester.pump();

      expect(find.byType(PrefHiderGeneric<int>), findsOneWidget);
      expect(find.byType(Placeholder), findsNothing);
    });

    testWidgets('string', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefHiderGeneric(
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
      expect(find.byType(PrefHiderGeneric<String>), findsOneWidget);
      expect(find.byType(Placeholder), findsOneWidget);

      service.set<String>('test', 'foo');
      expect(service.get<String>('test'), 'foo');
      await tester.pump();

      expect(find.byType(PrefHiderGeneric<String>), findsOneWidget);
      expect(find.byType(Placeholder), findsNothing);

      service.set<String>('test', 'bar');
      await tester.pump();

      expect(find.byType(PrefHiderGeneric<String>), findsOneWidget);
      expect(find.byType(Placeholder), findsOneWidget);

      service.set<int>('test', 11);
      await tester.pump();

      expect(find.byType(PrefHiderGeneric<String>), findsOneWidget);
      expect(find.byType(Placeholder), findsOneWidget);
    });

    testWidgets('string reversed', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefHiderGeneric(
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
      expect(find.byType(PrefHiderGeneric<String>), findsOneWidget);
      expect(find.byType(Placeholder), findsNothing);

      service.set<String>('test', 'foo');
      await tester.pump();

      expect(find.byType(PrefHiderGeneric<String>), findsOneWidget);
      expect(find.byType(Placeholder), findsOneWidget);

      service.set<String>('test', 'bar');
      await tester.pump();

      expect(find.byType(PrefHiderGeneric<String>), findsOneWidget);
      expect(find.byType(Placeholder), findsNothing);

      service.set<bool>('test', false);
      await tester.pump();

      expect(find.byType(PrefHiderGeneric<String>), findsOneWidget);
      expect(find.byType(Placeholder), findsNothing);
    });
  });
}
