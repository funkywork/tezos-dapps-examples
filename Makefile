.PHONY: all test build clean check-lint lint utop run


all: build

build:
	dune build

run: build
	dune exec bin/server/dapps.exe

test:
	dune runtest --no-buffer -j 1

clean:
	dune clean

doc: build
	dune build @doc

utop:
	dune utop

check-lint:
	dune build @fmt

lint:
	dune build @fmt --auto-promote

.PHONY: local-deps pinned-deps deps

local-deps:
	opam install . --deps-only --with-doc --with-test --with-dev-setup -y

pinned-deps: local-deps
	opam install nightmare -y
	opam install nightmare-dream -y
	opam install nightmare-tyxml -y
	opam install nightmare_js -y
	opam install nightmare_js-vdom -y
	opam install yourbones -y
	opam install yourbones-ppx -y
	opam install yourbones_js -y
	opam install yourbones_js-beacon -y

deps: pinned-deps
