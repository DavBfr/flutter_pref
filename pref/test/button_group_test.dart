// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pref/pref.dart';
import 'package:pref/src/custom/button_group.dart';

void main() {
  group('PrefButtonGroup', () {
    testWidgets('empty', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefButtonGroup<int>(
                pref: 'test',
                items: [],
              ),
            ),
          ),
        ),
      );

      expect(service.get<dynamic>('test'), isNull);
      expect(
          find.byWidgetPredicate((w) => w is ButtonGroup<int>), findsOneWidget);
    });

    testWidgets('basic', (WidgetTester tester) async {
      final service = PrefServiceCache();
      int? value;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: PrefButtonGroup<int>(
                pref: 'test',
                onChange: (v) => value = v,
                items: const [
                  ButtonGroupItem(value: 1, child: Text('one')),
                  ButtonGroupItem(value: 2, child: Text('two')),
                  ButtonGroupItem(value: 3, child: Text('three')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(value, isNull);
      expect(service.get<dynamic>('test'), isNull);
      expect(find.byType(RawMaterialButton), findsNWidgets(3));

      await tester.tap(find.byType(RawMaterialButton).first);
      await tester.pump();

      expect(value, equals(1));
      expect(service.get<int>('test'), equals(1));

      await tester.tap(find.byType(RawMaterialButton).last);
      await tester.pump();

      expect(value, equals(3));
      expect(service.get<int>('test'), equals(3));
    });

    testWidgets('invalid', (WidgetTester tester) async {
      final service = PrefServiceCache(defaults: <String, dynamic>{
        'test': '2',
      });
      int? value;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: PrefButtonGroup<int>(
                pref: 'test',
                onChange: (v) => value = v,
                items: const [
                  ButtonGroupItem(value: 1, child: Text('one')),
                  ButtonGroupItem(value: 2, child: Text('two')),
                  ButtonGroupItem(value: 3, child: Text('three')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(value, isNull);
      expect(service.get<dynamic>('test'), equals('2'));
      expect(find.byType(RawMaterialButton), findsNWidgets(3));

      await tester.tap(find.byType(RawMaterialButton).first);
      await tester.pump();

      expect(value, equals(1));
      expect(service.get<int>('test'), equals(1));

      await tester.tap(find.byType(RawMaterialButton).last);
      await tester.pump();

      expect(value, equals(3));
      expect(service.get<int>('test'), equals(3));
    });
  });

  group('ButtonGroup', () {
    testWidgets('disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonGroup<int>(
              disabled: true,
              items: const [
                ButtonGroupItem(value: 1, child: Text('one')),
                ButtonGroupItem(value: 2, child: Text('two')),
                ButtonGroupItem(value: 3, child: Text('three')),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(
          find.byWidgetPredicate((w) => w is ButtonGroup<int>), findsOneWidget);
    });
  });
}
