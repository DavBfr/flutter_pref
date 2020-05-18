// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pref/pref.dart';

void main() {
  group('PrefText', () {
    testWidgets('basic', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefText(
                pref: 'test',
              ),
            ),
          ),
        ),
      );

      expect(service.get<dynamic>('test'), isNull);
      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pump();

      expect(service.get<String>('test'), equals('hello'));
    });

    testWidgets('onChange', (WidgetTester tester) async {
      final service = PrefServiceCache();
      String value;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: PrefText(
                pref: 'test',
                onChange: (v) => value = v,
              ),
            ),
          ),
        ),
      );

      expect(service.get<dynamic>('test'), isNull);
      expect(value, isNull);
      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pump();

      expect(service.get<String>('test'), equals('hello'));
      expect(value, equals('hello'));
    });

    testWidgets(' invalid', (WidgetTester tester) async {
      final service = PrefServiceCache(defaults: <String, dynamic>{
        'test': false,
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefText(
                pref: 'test',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pump();

      expect(service.get<String>('test'), equals('hello'));
    });
  });
}
