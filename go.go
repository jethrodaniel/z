package main

// == Lexing
//
// Lexing is done concurrently by having the lexer output
// tokens from a channel.
//
// The parser then receives these, and knows it's at EOF if the channel
// is closed.
//
// Based/copied off of Rob Pike's concurrent lexer design: ...

// tok <- lexer.Tokens

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

// if atEOF() {
//   close(lexer.Tokens)
// }

// == Grammar
//
// expr
//   num
//

type Scanner struct {
}

type Parser struct {
}

// func (p *Parser) expr(tok Token) Expr {
//   expr := p.num(tok)
//   switch p.peek().Type {
//   case Newline, EOF, SemiColon:
//     return expr
//   }
//   p.errorf("after expression: unexpected %s", p.peek())
//   return nil
// }

type Value interface {
	String() string
	Eval() Value
	toType(valueType) Value
}
type valueType int

const (
	intType valueType = iota
	bigIntType
)

func main() {
}
