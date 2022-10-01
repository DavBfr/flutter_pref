// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:pref/pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Service Cache', () async {
    final service = PrefServiceCache();

    service.setDefaultValues(<String, dynamic>{
      // 'a': 'Test',
      'b': ['1', '2', '3'],
    });

    service.set('c', ['aa', 'bb']);

    print(service.getStringList('b'));
  });

  test('Service Shared', () async {
    SharedPreferences.setMockInitialValues({
      'b': ['d1', 'd2', 'd3'],
    });

    final service = await PrefServiceShared.init();

    service.setDefaultValues(<String, dynamic>{
      'a': 'Test',
      'b': ['1', '2', '3'],
    });

    print(service.get('b'));
  });
}
