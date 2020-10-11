#ifndef HOLYCC_SCANNER_HPP
#define HOLYCC_SCANNER_HPP

#include <string>

namespace holycc {

// Simple scanner class, just maintains position and line number in a string.
//
// Right now it uses a `std::string`, and returns `std::string`s instead of
// `chars` - this is to ease any conversions needed to handle UTF8.
//
// Eventually, the string here should index graphemes, so that `[0]` with
// Japanese, for example, returns the first _character_ as the human eye
// sees it.
//
// TODO: use a `string_view` here eventually
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
  std::string advance() {
    auto c = std::string(1,source[pos++]);
    if (c == "\n") line++;
    return c;
  }

  // Looks at the next character, without moving the scanner
  // @return the next character
  std::string peek() {
    return std::string(1, source[pos]);
  }

  // @param source The input text
  // @return A new scanner instance
  Scanner(std::string source) : source(source) { }
};

} // namespace holycc
#endif // HOLYCC_SCANNER_HPP
