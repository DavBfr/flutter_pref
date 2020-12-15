// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pref/pref.dart';

void main() {
  group('PrefDropdown', () {
    testWidgets('fullWidth empty', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefDropdown<int>(
                fullWidth: true,
                // title: Text('Hello'),
                pref: 'test',
                items: [],
              ),
            ),
          ),
        ),
      );

      expect(service.get<int>('test'), isNull);
      expect(find.byWidgetPredicate((w) => w is DropdownButton<int>),
          findsOneWidget);
    });

    testWidgets('fullWidth', (WidgetTester tester) async {
      final service = PrefServiceCache(defaults: <String, dynamic>{
        'test': 2,
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefDropdown<int>(
                fullWidth: true,
                title: Text('Hello'),
                pref: 'test',
                items: [
                  DropdownMenuItem(value: 1, child: Text('first')),
                  DropdownMenuItem(value: 2, child: Text('second')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(service.get<int>('test'), 2);

      expect(find.byWidgetPredicate((w) => w is DropdownButton<int>),
          findsOneWidget);

      await tester.tap(find.byWidgetPredicate((w) => w is DropdownButton<int>));
      await tester.pump();
      await tester
          .tap(find.byWidgetPredicate((w) => w is DropdownMenuItem<int>).first);

      expect(service.get<int>('test'), 1);
    });

    testWidgets('fullWidth onChange', (WidgetTester tester) async {
      final service = PrefServiceCache(defaults: <String, dynamic>{
        'test': 2,
      });

      int? value;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: PrefDropdown<int>(
                fullWidth: true,
                title: const Text('Hello'),
                pref: 'test',
                onChange: (int? v) => value = v,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('first')),
                  DropdownMenuItem(value: 2, child: Text('second')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(service.get<int>('test'), 2);
      expect(value, isNull);

      expect(find.byWidgetPredicate((w) => w is DropdownButton<int>),
          findsOneWidget);

      await tester.tap(find.byWidgetPredicate((w) => w is DropdownButton<int>));
      await tester.pump();
      await tester
          .tap(find.byWidgetPredicate((w) => w is DropdownMenuItem<int>).first);
      await tester.pump();

      expect(service.get<int>('test'), 1);
      expect(value, equals(1));
    });

    testWidgets('smallWidth', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefDropdown<int>(
                pref: 'test',
                fullWidth: false,
                items: [],
              ),
            ),
          ),
        ),
      );

      expect(service.get<int>('test'), isNull);
      expect(find.byWidgetPredicate((w) => w is DropdownButton<int>),
          findsOneWidget);
    });

    testWidgets('smallWidth invalid', (WidgetTester tester) async {
      final service = PrefServiceCache(defaults: <String, dynamic>{
        'test': '2',
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefDropdown<int>(
                pref: 'test',
                fullWidth: false,
                items: [
                  DropdownMenuItem(value: 1, child: Text('first')),
                  DropdownMenuItem(value: 2, child: Text('second')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(service.get<dynamic>('test'), equals('2'));
      expect(find.byWidgetPredicate((w) => w is DropdownButton<int>),
          findsOneWidget);

      await tester.tap(find.byWidgetPredicate((w) => w is DropdownButton<int>));
      await tester.pump();
      await tester
          .tap(find.byWidgetPredicate((w) => w is DropdownMenuItem<int>).first);
      await tester.pump();

      expect(service.get<int>('test'), 1);
    });
  });
}
