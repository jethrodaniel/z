#include <catch.hpp>
#include <vector>

#include <holycc/lexer.hpp>

using namespace std::string_literals;

TEST_CASE("lexer") {
  holycc::Lexer lex("42 + 5"s);

  auto tokens = lex.scan_tokens();

  std::vector<holycc::Token> expected{
    holycc::Token(holycc::Token::Type::NUMBER, "42", 1, 0, 1),
    holycc::Token(holycc::Token::Type::PLUS,   "+",  1, 3, 3),
    holycc::Token(holycc::Token::Type::NUMBER, "5",  1, 5, 5),
    holycc::Token(holycc::Token::Type::END,    "\0", 1, 6, 6)
  };

  REQUIRE(tokens == expected);
}
