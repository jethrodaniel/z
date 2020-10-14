#ifndef HOLYCC_TOKEN_HPP
#define HOLYCC_TOKEN_HPP

#include <sstream>
#include <string>
#include <utility>

using namespace std::string_literals;

namespace holycc {

class Token {
public:
  enum class Type {
    PLUS,     // +
    MINUS,    // -
    DIVIDE,   // /
    MULTIPLY, // *
    NUMBER,   // 123
    NEWLINE,  // \n
    END 			// EOF
  };

  // thanks, c++, I hate it.
  std::string type_name() const {
    switch(type) {
      case Type::PLUS:     return "PLUS"s;
      case Type::MINUS:    return "MINUS"s;
      case Type::DIVIDE:   return "DIVIDE"s;
      case Type::MULTIPLY: return "MULTIPLY"s;
      case Type::NUMBER:   return "NUMBER"s;
      case Type::NEWLINE:  return "NEWLINE"s;
      case Type::END:      return "END"s;
    }
    return "error!";
    throw fmt::format("Error: unknown token type `{}`", type);
  }

  static std::string t(Type type) {
    auto token = Token(type, "", 0, 0, 0);
    return token.type_name();
  }

  const Type type;
  const std::string lexeme;
  const int line,
            start,
            end;

  // @param  type   The token's type
  // @param  lexeme The text of this token
  // @param  line   The line where this token was found
  // @param  start  The starting index of this token
  // @param  end    The ending index of this token
  // @return        A new Token instance
  explicit Token(const Type type, std::string lexeme,
                 const int line, const int start, const int end)
    : type(type), lexeme(std::move(std::move(lexeme))), line(line), start(start), end(end) { }

  friend std::ostream &operator<<(std::ostream &output, const Token &t) {
    output << t.to_s();
    return output;
  }

  const std::string to_s() const {
    std::ostringstream out;
    out << "[" << line << ":" << start << "-" << end << "][" << type_name() << ", '" << lexeme << "']";
    return out.str();
  }

  friend bool operator==(const Token &t1, const Token &t2) {
    return t1.type   == t2.type   &&
           t1.lexeme == t2.lexeme &&
           t1.line   == t2.line   &&
           t1.start  == t2.start  &&
           t1.end    == t2.end;
  }
};

} // namespace holycc
#endif // HOLYCC_TOKEN_HPP
