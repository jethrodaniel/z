#ifndef HOLYCC_LEXER_HPP
#define HOLYCC_LEXER_HPP

#include <string>
#include <vector>
#include <regex>

#include <holycc/error.hpp>
#include <holycc/token.hpp>
#include <holycc/scanner.hpp>

using namespace std::string_literals;

namespace holycc {

class Lexer {
  Scanner scanner;
  std::vector<Token> tokens;
  unsigned int start = 1; // The start index of the current token

  // Adds a token to the list of tokens
  void add_token(Token::Type type) {
    auto lexeme = scanner.source.substr(start, scanner.pos - start);
    tokens.push_back(Token(type, lexeme, scanner.line, start, scanner.pos - 1));
  }

  bool is_digit(std::string n) {
    return std::regex_match(n, std::regex("[[:digit:]]"));
  }

  // TODO: only handles positive integers for now
  void numeric() {
    while (is_digit(scanner.peek())) {
      scanner.advance();
    }

    add_token(Token::Type::NUMBER);
  }

  // Read characters until the the next available token is formed
  void scan_token() {
    auto c = scanner.advance();
    if (c == "+")
      add_token(Token::Type::PLUS);
    else if (c == "-")
      add_token(Token::Type::MINUS);
    else if (c == "/")
      add_token(Token::Type::DIVIDE);
    else if (c == "*")
      add_token(Token::Type::MULTIPLY);
    else if (c == " ")
      return; // skip whitespace
    else if (c == "\n")
      add_token(Token::Type::NEWLINE);
    else if (is_digit(c))
      numeric();
    else {
      auto error = "[lexer] Unexpected character '"s + c + "'.";
      throw Error(error, scanner.line, start);
    }
  }

public:
  // @param source The input text to scan
  // @return A new lexer instance
  Lexer(std::string source) : scanner(source) { }

  // @return A list of all tokens from the input
  std::vector<Token> scan_tokens() {
    // build tokens until the end of input
    while (!scanner.is_eof()) {
      start = scanner.pos;
      scan_token();
    }
    return tokens;
  }
};

} // namespace holycc
#endif // HOLYCC_LEXER_HPP
