// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pref/pref.dart';

void main() {
  group('PrefCheckbox', () {
    testWidgets('basic', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefCheckbox(
                pref: 'test',
              ),
            ),
          ),
        ),
      );

      expect(service.get<bool>('test'), isNull);
      expect(find.byType(Checkbox), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(service.get<bool>('test'), isFalse);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(service.get<bool>('test'), isTrue);
    });

    testWidgets('reversed', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefCheckbox(
                pref: 'test',
                reversed: true,
              ),
            ),
          ),
        ),
      );

      expect(service.get<bool>('test'), isNull);
      expect(find.byType(Checkbox), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(service.get<bool>('test'), isTrue);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(service.get<bool>('test'), isFalse);
    });

    testWidgets('onChange', (WidgetTester tester) async {
      bool? value;
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: PrefCheckbox(
                pref: 'test',
                onChange: (v) => value = v,
              ),
            ),
          ),
        ),
      );

      expect(service.get<bool>('test'), isNull);
      expect(value, isNull);
      expect(find.byType(Checkbox), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(service.get<bool>('test'), isFalse);
      expect(value, isFalse);

      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(service.get<bool>('test'), isTrue);
      expect(value, isTrue);
    });

    testWidgets('default valid', (WidgetTester tester) async {
      final service = PrefServiceCache(defaults: <String, dynamic>{
        'test': true,
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefCheckbox(
                pref: 'test',
              ),
            ),
          ),
        ),
      );

      expect(service.get<bool>('test'), isTrue);

      expect(find.byType(Checkbox), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(service.get<bool>('test'), isFalse);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(service.get<bool>('test'), isTrue);
    });

    testWidgets('default invalid', (WidgetTester tester) async {
      final service = PrefServiceCache(defaults: <String, dynamic>{
        'test': '123',
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefCheckbox(
                pref: 'test',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(service.get<bool>('test'), isFalse);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(service.get<bool>('test'), isTrue);
    });
  });
}
