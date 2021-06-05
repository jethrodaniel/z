package main

import (
	"flag"
	"fmt"
	"os"
)

const Version = "0.2.0"

const Usage = `z compiler.
Usage: z [command] [arguments]                                                                   (1/3 results) [1029/1166]
    lex                              Lex input, output tokens
    parse                            Parse input, output AST
    dot                              Parse input, output graphviz dot
    compile                          Compile input, output assembly
    run                              Compile and run input
    obj                              Analyze object files
    -i                               Get input from stdin
    -c                               Get input from string
    -v, --version                    Show the version
    -h, --help                       Show this help    Usage: led [switches] [--] [file]
`

func main() {
	var (
		help    = flag.Bool("h", false, "show this help")
		version = flag.Bool("V", false, "show the version")
	)
	flag.Parse()

	if *help {
		fmt.Println(Usage)
		os.Exit(0)
	}

	if *version {
		fmt.Println("v" + Version)
		os.Exit(0)
	}

	fmt.Println("oof")
}
