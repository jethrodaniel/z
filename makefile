default: test

build: fmt
	shards install
	shards build

fmt:
	crystal tool format src spec

test: build
	crystal spec -v

clean:
	rm -rfv bin
