// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pref/pref.dart';

void main() {
  group('PrefSlider', () {
    testWidgets('basic', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefSlider<double>(
                pref: 'test',
              ),
            ),
          ),
        ),
      );

      expect(service.get<double>('test'), isNull);
      expect(find.byType(Slider), findsOneWidget);

      await tester.tap(find.byType(Slider));
      await tester.pump();

      expect(service.get<double>('test'), isNotNull);
    });

    testWidgets('onChange', (WidgetTester tester) async {
      int? value;
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: PrefSlider<int>(
                pref: 'test',
                onChange: (num v) => value = v.toInt(),
              ),
            ),
          ),
        ),
      );

      expect(service.get<int>('test'), isNull);
      expect(value, isNull);
      expect(find.byType(Slider), findsOneWidget);

      await tester.tap(find.byType(Slider));
      await tester.pump();

      expect(service.get<int>('test'), isNotNull);
      expect(value, isNotNull);
    });

    testWidgets('invalid', (WidgetTester tester) async {
      final service = PrefServiceCache(defaults: <String, dynamic>{
        'test': '123',
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefSlider(
                pref: 'test',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Slider), findsOneWidget);

      await tester.tap(find.byType(Slider));
      await tester.pump();

      expect(service.get<num>('test'), isNotNull);
    });
  });
}
