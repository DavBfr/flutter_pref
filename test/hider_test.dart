// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pref/pref.dart';

void main() {
  group('PrefHider', () {
    testWidgets('basic', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefHider(
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
      expect(find.byType(PrefHider), findsOneWidget);
      expect(find.byType(Placeholder), findsNothing);

      service.set<bool>('test', true);
      await tester.pump();

      expect(find.byType(PrefHider), findsOneWidget);
      expect(find.byType(Placeholder), findsOneWidget);

      service.set<bool>('test', false);
      await tester.pump();

      expect(find.byType(PrefHider), findsOneWidget);
      expect(find.byType(Placeholder), findsNothing);

      service.set<String>('test', 'ON');
      await tester.pump();

      expect(find.byType(PrefHider), findsOneWidget);
      expect(find.byType(Placeholder), findsNothing);
    });

    testWidgets('reversed', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefHider(
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
      expect(find.byType(PrefHider), findsOneWidget);
      expect(find.byType(Placeholder), findsOneWidget);

      service.set<bool>('test', true);
      await tester.pump();

      expect(find.byType(PrefHider), findsOneWidget);
      expect(find.byType(Placeholder), findsNothing);

      service.set<bool>('test', false);
      await tester.pump();

      expect(find.byType(PrefHider), findsOneWidget);
      expect(find.byType(Placeholder), findsOneWidget);

      service.set<String>('test', 'ON');
      await tester.pump();

      expect(find.byType(PrefHider), findsOneWidget);
      expect(find.byType(Placeholder), findsOneWidget);
    });
  });
}
