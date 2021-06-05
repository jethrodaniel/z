package lex

// Type identifies the kind/type of a token
type Type int

// Token is a lexeme, the smallest unit of the language
type Token struct {
	Type  int
	Value string
}

const (
	EOF   Type = iota // so the closed channel outputs EOF
	Error             // error occured, value is the error message
)
