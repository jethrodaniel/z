#ifndef HOLYCC_PARSER_HPP
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

  Token peek() {
    return tokens[pos];
  }

  Token previous() {
    if (pos == 0) throw "there is no previous token";
    return tokens[pos - 1];
  }

  bool is_eof() {
    return pos >= tokens.size();
  }

  Token advance() {
    if (!is_eof()) pos++;
    return previous();
  }

  bool consume(std::string str) {
    if (peek().lexeme == str) {
      pos++;
      return true;
    } else return false;
  }

  bool consume(Token::Type type) {
    if (peek().type == type) {
      pos++;
      return true;
    } else return false;
  }

  bool expect(std::string str) {
    if (consume(str)) return true;
    else {
      auto err = fmt::format("Expected `{}`, got `{}`", str, peek().lexeme);
      throw Error(err, peek().line, peek().start);
      // return false;
    }
  }

  bool expect(Token::Type type) {
    if (consume(type)) return true;
    else {
      auto err = fmt::format("Expected `{}`, got `{}`", Token::t(type), peek().type_name());
      throw Error(err, peek().line, peek().start);
      // return false;
    }
  }

  // expr    = mul ("+" mul | "-" mul)*
  // mul     = primary ("*" primary | "/" primary)*
  // primary = num | "(" expr ")"

public:
  explicit Parser(std::string source) : lexer(Lexer(source)) { }

  ast::Node parse() {
    tokens = lexer.scan_tokens();

    expect(Token::Type::NUMBER);
    expect("+");
    expect("5");

    ast::Node node(ast::Node::Type::ADD);
    node.children = {"42"s};
    return node;
  }
};

} // namespace holycc
#endif // HOLYCC_PARSER_HPP
