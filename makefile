NAME = z

default: test

install: clean
	go install github.com/jethrodaniel/$(NAME)

build: fmt
	mkdir -p bin
	go build -o bin/$(NAME) .

test: build
	go test -v ./...

clean:
	go clean github.com/jethrodaniel/$(NAME)
	rmdir bin

fmt:
	go fmt ./...

install_go:
	wget https://golang.org/dl/go1.16.4.linux-amd64.tar.gz
	tar xzvf go1.16.4.linux-amd64.tar.gz -C ~/
	echo 'export PATH="$$PATH:$$HOME/go/bin"' >> ~/.bashrc
