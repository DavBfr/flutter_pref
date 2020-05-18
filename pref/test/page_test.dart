// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pref/pref.dart';

void main() {
  group('PrefPage', () {
    testWidgets('basic', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
              service: service,
              child: const PrefPage(
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
            body: PrefPage(
              children: [
                Text('Hello'),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isInstanceOf<FlutterError>());
    });
  });

  group('PrefPageButton', () {
    testWidgets('basic', (WidgetTester tester) async {
      final service = PrefServiceCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrefService(
                service: service,
                child: const PrefPageButton(
                  page: PrefPage(
                    children: [
                      Text('Hello'),
                    ],
                  ),
                )),
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
