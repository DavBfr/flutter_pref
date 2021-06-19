// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:pref/pref.dart';

void main() {
  test('PrefServiceCache', () {
    final pref = PrefServiceCache();

    pref.set('test', null);
    expect(pref.get<bool?>('test'), null);
  });
}
