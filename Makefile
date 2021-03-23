# Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
# All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

FLUTTER?=$(realpath $(dir $(realpath $(dir $(shell which flutter)))))
FLUTTER_BIN=$(FLUTTER)/bin/flutter
DART_BIN=$(FLUTTER)/bin/dart
DART_SRC=$(shell find . -name '*.dart')

all: pref/pubspec.lock pref/example/.metadata format

format: format-dart

format-dart: $(DART_SRC)
	$(DART_BIN) format --fix $^

pref/pubspec.lock: pref/pubspec.yaml
	cd pref; $(FLUTTER_BIN) pub get

pref/example/.metadata:
	cd pref/example; $(FLUTTER_BIN) create -t app --no-overwrite --org net.nfet --project-name example .
	rm -rf pref/example/test pref/example/integration_test

clean:
	git clean -fdx -e .vscode

node_modules:
	npm install lcov-summary

test: pref/pubspec.lock node_modules
	cd pref; $(FLUTTER_BIN) test --coverage --coverage-path lcov.info
	cat pref/lcov.info | node_modules/.bin/lcov-summary

test-readme:
	cd tools; $(FLUTTER_BIN) pub get
	cd tools; $(DART_BIN) extract_readme.dart

publish: format analyze clean
	test -z "$(shell git status --porcelain)"
	find pref -name pubspec.yaml -exec sed -i -e 's/^dependency_overrides:/_dependency_overrides:/g' '{}' ';'
	cd pref; $(DART_BIN) pub publish -f
	find pref -name pubspec.yaml -exec sed -i -e 's/^_dependency_overrides:/dependency_overrides:/g' '{}' ';'
	git tag $(shell grep version pref/pubspec.yaml | sed 's/version\s*:\s*/v/g')

.pana:
	$(DART_BIN) pub global activate pana
	touch $@

analyze: .pana pref/pubspec.lock pref/example/.metadata $(DART_SRC)
	$(DART_BIN) pub global run pana --no-warning --source path pref

.PHONY: format format-dart clean publish test fix analyze
