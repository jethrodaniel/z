#ifndef HOLYCC_LEXER_HPP
#define HOLYCC_LEXER_HPP

#include <string>
#include <vector>

#include <holycc/error.hpp>
#include <holycc/token.hpp>
#include <holycc/scanner.hpp>

using namespace std::string_literals;

namespace holycc {

class Lexer {
  Scanner scanner;
  std::vector<Token> tokens; // list of the current tokens

  unsigned int start = 1; // The start of the current token

  // Adds a token to the list of tokens
  void add_token(Token::Type type) {
    auto lexeme = scanner.source.substr(start, scanner.pos - start);
    tokens.push_back(Token(type, lexeme, scanner.line, start, scanner.pos - 1));
  }

  void numeric() {
    while (std::isdigit(scanner.peek())) {
      scanner.advance();
    }

    add_token(Token::Type::NUMBER);
  }

  // Read characters until the the next available token is formed
  void scan_token() {
    char c = scanner.advance();
    switch (c) {
      case '+': add_token(Token::Type::PLUS); break;
      case '-': add_token(Token::Type::MINUS); break;
      case '/': add_token(Token::Type::DIVIDE); break;
      case '*': add_token(Token::Type::MULTIPLY); break;

      // Ignore whitespace
      case ' ':  break;
      case '\t': break;

      // newlines
      case '\r': break; // todo \r\n
      case '\n': add_token(Token::Type::NEWLINE); break;

      case '\0': add_token(Token::Type::END); break;

      default:
        if (std::isdigit(c))
          numeric();
        else {
          auto error = "Unexpected character '"s + c + "'.";
          // TODO: return expected<T, error> here
          throw Error(error, scanner.line, start);
        }
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

    // this is a bit ugly, but looping until EOF is pretty sane
    start++;
    scanner.advance();
    add_token(Token::Type::END);

    return tokens;
  }
};

} // namespace holycc
#endif // HOLYCC_LEXER_HPP
