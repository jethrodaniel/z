#ifndef HOLYCC_PARSER_HPP
#include <iostream>
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
    if (tokens.size() == 0)
      throw fmt::format("[parser] missing input");
    if (is_eof()) {
      auto err = fmt::format("[parser] parsed past EOF; pos: {}", pos);
      throw Error(err, previous().line, previous().start);
    }

    return tokens[pos];
  }

  Token previous() {
    if (pos == 0) throw "[parser] there is no previous token"s;
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
      auto err = fmt::format("[parser] Expected `{}`, got `{}`", str, peek().lexeme);
      throw Error(err, peek().line, peek().start);
    }
  }
  bool expect(Token::Type type) {
    if (consume(type)) return true;
    else {
      auto err = fmt::format("[parser] Expected `{}`, got `{}`", Token::t(type), peek().type_name());
      throw Error(err, peek().line, peek().start);
      // return false;
    }
  }

  // expr    = mul ("+" mul | "-" mul)*
  // mul     = primary ("*" primary | "/" primary)*
  // primary = num | "(" expr ")"

  ast::Node primary() {
    ast::Node node(ast::Node::Type::LIT);

    if (consume(Token::Type::NUMBER))
      node.children = {previous().lexeme};
    /* else if (consume("("s)) */
    /*   expr(); */
    else
      throw Error("[parser] Expected a literal or an expression"s, peek().line, peek().start);

    return node;
  }

public:
  explicit Parser(std::string source) : lexer(Lexer(source)) { }

  ast::Node parse() {
    tokens = lexer.scan_tokens();
    return primary();
  }
};

} // namespace holycc
#endif // HOLYCC_PARSER_HPP
