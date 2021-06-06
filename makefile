default: test

build: fmt
	shards install
	shards build

fmt:
	crystal tool format src spec

test: build
	crystal spec -v --order random --tag '~bench'

bench: build
	crystal spec -v --order random --tag 'bench' --release

clean:
	rm -rfv bin
