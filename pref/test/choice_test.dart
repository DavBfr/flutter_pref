// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pref/pref.dart';

void main() {
  group('PrefChoice', () {
    testWidgets('basic', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefChoice(
                pref: 'test',
                items: [
                  DropdownMenuItem(value: 1, child: Text('s1')),
                  DropdownMenuItem(value: 2, child: Text('s2')),
                  DropdownMenuItem(value: 3, child: Text('s3')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(service.get<int>('test'), isNull);
      expect(find.byType(PrefDialogButton), findsOneWidget);

      await tester.tap(find.byType(PrefDialogButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('s2'));
      await tester.pump();

      expect(service.get<int>('test'), 2);

      await tester.tap(find.byType(PrefDialogButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('s3'));
      await tester.pump();

      expect(service.get<int>('test'), 3);
    });

    testWidgets('onChange', (WidgetTester tester) async {
      int? value;
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: PrefChoice(
                pref: 'test',
                items: const [
                  DropdownMenuItem(value: 1, child: Text('s1')),
                  DropdownMenuItem(value: 2, child: Text('s2')),
                  DropdownMenuItem(value: 3, child: Text('s3')),
                ],
                onChange: (v) => value = v,
              ),
            ),
          ),
        ),
      );

      expect(service.get<int>('test'), isNull);
      expect(value, isNull);
      expect(find.byType(PrefDialogButton), findsOneWidget);

      await tester.tap(find.byType(PrefDialogButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('s2'));
      await tester.pump();

      expect(service.get<int>('test'), 2);
      expect(value, 2);

      await tester.tap(find.byType(PrefDialogButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('s1'));
      await tester.pump();

      expect(service.get<int>('test'), 1);
      expect(value, 1);
    });

    testWidgets('onChange with submit', (WidgetTester tester) async {
      int? value;
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: PrefChoice(
                pref: 'test',
                items: const [
                  DropdownMenuItem(value: 1, child: Text('s1')),
                  DropdownMenuItem(value: 2, child: Text('s2')),
                  DropdownMenuItem(value: 3, child: Text('s3')),
                ],
                submit: const Text('ok'),
                onChange: (v) => value = v,
              ),
            ),
          ),
        ),
      );

      expect(service.get<int>('test'), isNull);
      expect(value, isNull);
      expect(find.byType(PrefDialogButton), findsOneWidget);

      await tester.tap(find.byType(PrefDialogButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('s2'));
      await tester.pump();

      expect(service.get<int>('test'), isNull);
      expect(value, isNull);

      await tester.tap(find.text('ok'));
      await tester.pump();

      expect(service.get<int>('test'), 2);
      expect(value, 2);
    });
  });
}
