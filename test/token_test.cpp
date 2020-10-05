#include <catch.hpp>

#include <holycc/token.hpp>

TEST_CASE("tokens") {
  auto t = holycc::Token(holycc::Token::Type::PLUS, "+", 1, 0, 1);

  REQUIRE(t.type == holycc::Token::Type::PLUS);
  REQUIRE(t.lexeme == "+");
  REQUIRE(t.line == 1);
  REQUIRE(t.start == 0);
  REQUIRE(t.end == 1);

  SECTION("#==") {
    auto o = holycc::Token(holycc::Token::Type::PLUS, "+", 1, 0, 1);
    REQUIRE(t == o);
  }
}
