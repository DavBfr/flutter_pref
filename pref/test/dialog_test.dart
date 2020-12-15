// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pref/pref.dart';

void main() {
  group('PrefDialog', () {
    testWidgets('basic', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefDialog(
                children: [
                  Text('Hello'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('no service', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrefDialog(
              children: [
                Text('Hello'),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isInstanceOf<Error>());
    });

    testWidgets('cache', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefDialog(
                submit: Text('OK'),
                onlySaveOnSubmit: true,
                children: [
                  PrefCheckbox(pref: 'test'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(Checkbox), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(service.get<dynamic>('test'), isNull);

      await tester.tap(find.byType(FlatButton));
      await tester.pump();

      expect(service.get<dynamic>('test'), isFalse);
    });
  });

  group('PrefDialogButton', () {
    testWidgets('basic', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefDialogButton(
                dialog: PrefDialog(
                  children: [
                    Text('Hello'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Text), findsNothing);

      // await tester.tap(find.byType(ListTile));
      // await tester.pump();

      // expect(find.byType(Text), findsOneWidget);
    });
  });
}
