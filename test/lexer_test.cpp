#include <catch.hpp>
#include <vector>

#include <holycc/lexer.hpp>

using namespace std::literals::string_literals;

TEST_CASE("lexer") {
  holycc::Lexer lex("42 + 5"s);

  auto tokens = lex.scan_tokens();

  std::vector<holycc::Token> expected{
    holycc::Token(holycc::Token::Type::NUMBER, "42",  1, 0, 2),
    holycc::Token(holycc::Token::Type::PLUS,   "+",   1, 3, 4),
    holycc::Token(holycc::Token::Type::NUMBER, "5",   1, 5, 6),
    holycc::Token(holycc::Token::Type::END,    "END", 1, 6, 7)
  };

  REQUIRE(tokens == expected);
}
