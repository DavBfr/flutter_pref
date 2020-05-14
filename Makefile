# Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
# All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

DART_SRC=$(shell find . -name '*.dart')

all: format

format: format-dart

format-dart: $(DART_SRC)
	dartfmt -w --fix $^

clean:
	git clean -fdx -e .vscode

node_modules:
	npm install lcov-summary

test: node_modules
	flutter test --coverage --coverage-path lcov.info
	dart bin/json_intl.dart -s test/data -d test/intl.dart -v
	cat lcov.info | node_modules/.bin/lcov-summary

publish: format analyze clean
	test -z "$(shell git status --porcelain)"
	find . -name pubspec.yaml -exec sed -i -e 's/^dependency_overrides:/_dependency_overrides:/g' '{}' ';'
	pub publish -f
	find . -name pubspec.yaml -exec sed -i -e 's/^_dependency_overrides:/dependency_overrides:/g' '{}' ';'
	git tag $(shell grep version pubspec.yaml | sed 's/version\s*:\s*/v/g')

.dartfix:
	pub global activate dartfix
	touch $@

.pana:
	pub global activate pana
	touch $@

fix: .dartfix $(DART_SRC)
	pub global run dartfix --overwrite .

analyze: $(DART_SRC)
	dartanalyzer --fatal-infos --fatal-warnings --fatal-hints --fatal-lints -v .

pana: .pana
	pub global run pana --no-warning --source path .

.PHONY: format format-dart clean publish test fix analyze

lib/src/pubspec.dart: pubspec.yaml
	flutter pub run pubspec_extract -s $^ -d $@
