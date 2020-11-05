default: install
run: ./bin/holycc
spec: install
	crystal spec
fmt:
	crystal tool format exe/* src/*
./bin/holycc: install fmt
	./$@
install:
	shards install
	shards build
tmp:
	mkdir -p tmp
clean:
	rm -rf tmp bin
crystal: tmp libevent
	wget https://github.com/crystal-lang/crystal/releases/download/0.35.1/crystal-0.35.1-1-linux-x86_64.tar.gz -P tmp
	cd tmp && tar -xzvf crystal-0.35.1-1-linux-x86_64.tar.gz -C /usr/local
	cd tmp && sudo ln -fvs /usr/local/crystal-0.35.1-1/bin/* /usr/bin/
libevent:
	cd third_party/libevent && ./autogen.sh && ./configure && make && sudo make install
	sh -c 'lib=/usr/local/lib/; conf=/etc/ld.so.conf; grep $lib $conf || echo $lib | sudo tee -a $conf'
