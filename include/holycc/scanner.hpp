#ifndef HOLYCC_SCANNER_HPP
#define HOLYCC_SCANNER_HPP

#include <string>

namespace holycc {

// Simple scanner class, just maintains position and line number in a string.
class Scanner {
public:
  const std::string source;
  unsigned int pos = 0, line = 1;

  // @return Whether or not the scanner is at the end of input
  bool is_eof() {
    return pos >= source.size();
  }

  // Moves the scanner to the next character
  // @return the previous character
  char advance() {
    auto c = source[pos++];
    if (c == '\n') line++;
    return c;
  }

  // Looks at the next character, without moving the scanner
  // @return the next character
  char peek() {
    return is_eof() ? '\0' : source[pos];
  }

  // @param source The input text
  // @return A new scanner instance
  Scanner(std::string source) : source(source) { }
};

} // namespace holycc
#endif // HOLYCC_SCANNER_HPP
