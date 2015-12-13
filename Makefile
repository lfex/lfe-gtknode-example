GTK2_RC_FILES=priv/gtk-2.0/gtkrc

all: clean deps build run

clean:
	rebar clean

deps:
	rebar get-deps

build:
	rebar compile

run:
	erl \
	-pa ./ebin -pa ./deps/gtknode/ebin \
	-pa ./ebin -pa ./deps/lfe/ebin \
	-sname test -s top

.PHONY: deps
