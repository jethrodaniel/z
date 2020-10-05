#ifndef HOLYCC_LEXER_HPP
#define HOLYCC_LEXER_HPP

#include <iostream>
#include <string>
#include <vector>

#include <holycc/error.hpp>
#include <holycc/token.hpp>

namespace holycc {

class Lexer {
  const std::string source;  // The source text to process
  std::vector<Token> tokens; // A list of the current tokens

  unsigned int start   = 0,  // The start of the current token
               current = 0,  // The index of the current token
               line    = 1;  // The line number of the current token

  // @return Whether or not the scanner is at the end of input
  bool is_eof() {
    return current >= source.size();
  }

  // Moves the scanner to the next character
  // @return the previous character
  char advance() {
    return source[current++];
  }

  // Adds a token to the list of tokens
  void add_token(Token::Type type) {
    auto lexeme = source.substr(start, current - start);
    tokens.push_back(Token(type, lexeme, line, start, current));
  }

  // Looks at the next character, without moving the scanner
  // @return the next character
  char peek() {
    if (is_eof())
      return '\0';
    else
      return source[current];
  }

  void numeric() {
    while (std::isdigit(peek())) {
      advance();
    }

    add_token(Token::Type::NUMBER);
  }

  // Read characters until the the next available token is formed
  void scan_token() {
    char c = advance();
    switch (c) {
      case '+': add_token(Token::Type::PLUS); break;
      case '-': add_token(Token::Type::MINUS); break;
      case '/': add_token(Token::Type::DIVIDE); break;
      case '*': add_token(Token::Type::MULTIPLY); break;
      case ' ':  // Ignore whitespace
      case '\t':
      case '\r': break;
      case '\n':
        add_token(Token::Type::NEWLINE);
        line++;
        break;
      default:
        if (std::isdigit(c))
          numeric();
        else {
          auto error = std::string("Unexpected character '") + c + "'.";
          // TODO: return expected<T, error> here
          throw Error(error, line, start);
        }
    }
  }

public:
  // @param  source The input text to scan
  // @return        A new lexer instance
  Lexer(std::string source) : source(source) { }

  // @return A list of all tokens from the input
  std::vector<Token> scan_tokens() {
    // Until the end of input is found, build tokens
    while (!is_eof()) {
      start = current;
      scan_token();
    }
    if (current != 0)
      start++;

    current++;

    tokens.push_back(Token(Token::Type::END, "END", line, start, current));
    return tokens;
  }
};

} // namespace holycc
#endif // HOLYCC_LEXER_HPP
