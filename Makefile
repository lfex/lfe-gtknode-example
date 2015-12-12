
all: clean deps build run

clean:
	rebar clean

deps:
	rebar get-deps

build:
	rebar compile

run:
	erl -pa ./ebin -pa ./deps/gtknode/ebin -sname test -s top

.PHONY: deps
