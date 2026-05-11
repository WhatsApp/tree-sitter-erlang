TREE_SITTER=npx tree-sitter-cli

all: fmt gen test

fmt:
	./node_modules/.bin/prettier --write grammar.js

.PHONY: test
test: gen
	$(TREE_SITTER) test

.PHONY: test-highlight
test-highlight:
	# Note: test-highlight uses a filter for non-existent corpus
	# tests, so only highlights run. And does not gen.
	$(TREE_SITTER) test-highlight

.PHONY: update
update: gen
	$(TREE_SITTER) test --update

.PHONY: debug
debug: gen
	$(TREE_SITTER) test -d

.PHONY: gen
gen:
	$(TREE_SITTER) generate
	python3 -c 'import sys; [open(f,"w").write(c) for f in sys.argv[1:] for c in ["// @"+"generated\n\n"+open(f).read()]]' src/parser.c src/tree_sitter/parser.h src/tree_sitter/alloc.h src/tree_sitter/array.h
	python3 -c 'import sys,json; [open(f,"w").write(c) for f in sys.argv[1:] for c in [json.dumps({**json.load(open(f)),"@"+"generated":True},indent=2)+"\n"]]' src/grammar.json
	python3 -c 'import sys,json; [open(f,"w").write(c) for f in sys.argv[1:] for c in [json.dumps(json.load(open(f))+[{"@"+"generated":True}],indent=2)+"\n"]]' src/node-types.json

.PHONY: deps
deps:
	npm install

.PHONY: web
web: wasm
	$(TREE_SITTER) web-ui

.PHONY: wasm
wasm:
	$(TREE_SITTER) build-wasm

.PHONY: publish
publish: all wasm
	cp ./tree-sitter-erlang.wasm ./docs
