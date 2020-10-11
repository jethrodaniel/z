#ifndef HOLYCC_PARSER_HPP
#define HOLYCC_PARSER_HPP

//#include <iostream>
//#include <string>
//#include <vector>

#include <sstream>
#include <optional>

#include <holycc/error.hpp>
#include <holycc/lexer.hpp>
#include <holycc/ast.hpp>

namespace holycc {

class Parser {
  Lexer lexer;
  std::vector<Token> tokens;
  int pos = 0;

  // const std::vector<Token::Type> REDIRECTION_OPS = {
  //   Token::Type::REDIRECT_LEFT,
  //   Token::Type::DREDIRECT_LEFT,
  //   Token::Type::REDIRECT_RIGHT,
  //   Token::Type::DREDIRECT_RIGHT
  // };

  // @return The current token
  Token peek() {
    return tokens[pos];
  }

  // @return The previous token
  Token previous() {
    if (pos == 0) throw "there is no previous token";
    return tokens[pos - 1];
  }

  // @return Whether or not the parser is the end of input
  bool is_eof() {
    return pos >= tokens.size();
  }

  // Moves the parser to the next token
  //
  // @return The previous token
  Token advance() {
    if (!is_eof()) pos++;
    return previous();
  }

  // Checks the type of the current token against a list
  //
  // @param  types A list of types to compare with
  // @return Whether the current token is of a type in types
  bool match(std::vector<Token::Type> types) {
    for (auto t : types)
      if (peek().type == t)
        return true;

    return false;
  }

  // expr    = mul ("+" mul | "-" mul)*
  // mul     = primary ("*" primary | "/" primary)*
  // primary = num | "(" expr ")"

public:
  // @param source The source input
  // @return A new parser instance
  explicit Parser(std::string source) : lexer(Lexer(source)) { }

  // Parse and run the input
  //
  // @return A new AST tree
  ast::Node parse() {
    ast::Node node(ast::Node::Type::ADD);
    tokens = lexer.scan_tokens();
    return node;
  }
};

} // namespace holycc
#endif // HOLYCC_PARSER_HPP
