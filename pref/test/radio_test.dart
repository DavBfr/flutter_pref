// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pref/pref.dart';

void main() {
  group('PrefRadio', () {
    testWidgets('basic', (WidgetTester tester) async {
      final service = PrefServiceCache();
      int value;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: PrefPage(
                children: [
                  const PrefRadio<int>(
                    pref: 'test',
                    value: 1,
                  ),
                  const PrefRadio<int>(
                    pref: 'test',
                    value: 2,
                  ),
                  PrefRadio<int>(
                    pref: 'test',
                    value: 3,
                    onSelect: () => value = 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(service.get<dynamic>('test'), isNull);
      expect(find.byWidgetPredicate((w) => w is Radio<int>), findsNWidgets(3));
      expect(value, isNull);

      await tester.tap(find.byWidgetPredicate((w) => w is Radio<int>).first);
      await tester.pump();

      expect(service.get<int>('test'), equals(1));
      expect(value, isNull);

      await tester.tap(find.byWidgetPredicate((w) => w is Radio<int>).last);
      await tester.pump();

      expect(service.get<int>('test'), equals(3));
      expect(value, equals(3));
    });

    testWidgets('invalid', (WidgetTester tester) async {
      final service = PrefServiceCache(defaults: <String, dynamic>{
        'test': 'hello',
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefPage(
                children: [
                  PrefRadio<int>(
                    pref: 'test',
                    value: 1,
                  ),
                  PrefRadio<int>(
                    pref: 'test',
                    value: 2,
                  ),
                  PrefRadio<int>(
                    pref: 'test',
                    value: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(service.get<dynamic>('test'), equals('hello'));
      expect(find.byWidgetPredicate((w) => w is Radio<int>), findsNWidgets(3));

      await tester.tap(find.byWidgetPredicate((w) => w is Radio<int>).first);
      await tester.pump();

      expect(service.get<int>('test'), equals(1));

      await tester.tap(find.byWidgetPredicate((w) => w is Radio<int>).last);
      await tester.pump();

      expect(service.get<int>('test'), equals(3));
    });
  });
}
