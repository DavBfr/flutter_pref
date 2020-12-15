# Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
# All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

DART_SRC=$(shell find . -name '*.dart')

all: pref/example/.metadata format

format: format-dart

format-dart: $(DART_SRC)
	dartfmt -w --fix $^

pref/example/.metadata:
	cd pref/example; flutter create -t app --no-overwrite --org net.nfet --project-name example .
	rm -rf pref/example/test pref/example/integration_test
	cd pref; flutter pub get

clean:
	git clean -fdx -e .vscode

node_modules:
	npm install lcov-summary

test: node_modules
	cd pref; flutter test --coverage --coverage-path lcov.info
	cat pref/lcov.info | node_modules/.bin/lcov-summary

test-readme:
	cd tools; flutter pub get
	cd tools; dart extract_readme.dart

publish: format analyze clean
	test -z "$(shell git status --porcelain)"
	find pref -name pubspec.yaml -exec sed -i -e 's/^dependency_overrides:/_dependency_overrides:/g' '{}' ';'
	cd pref; pub publish -f
	find pref -name pubspec.yaml -exec sed -i -e 's/^_dependency_overrides:/dependency_overrides:/g' '{}' ';'
	git tag $(shell grep version pref/pubspec.yaml | sed 's/version\s*:\s*/v/g')

.dartfix:
	pub global activate dartfix
	touch $@

.pana:
	pub global activate pana
	touch $@

fix: .dartfix $(DART_SRC)
	cd pref; pub global run dartfix --overwrite .

analyze: pref/example/.metadata $(DART_SRC)
	cd pref; dartanalyzer --fatal-infos --fatal-warnings --fatal-hints --fatal-lints -v .

pana: pref/example/.metadata .pana
	cd pref; flutter pub global run pana --no-warning --source path .

.PHONY: format format-dart clean publish test fix analyze
