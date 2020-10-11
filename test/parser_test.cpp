#include <catch.hpp>
#include <vector>

#include <holycc/parser.hpp>

using namespace std::string_literals;

TEST_CASE("parser") {
  holycc::Parser parser("42 + 5"s);

  auto node = parser.parse();

  holycc::ast::Node expected(
    holycc::ast::Node::Type::ADD,
    std::vector<std::variant<holycc::ast::Node, std::string>>{
      holycc::Token(holycc::Token::Type::NUMBER, "42", 1, 0, 1),
      holycc::Token(holycc::Token::Type::NUMBER, "5", 1, 5, 5),
    }
  );
  REQUIRE(node == expected);
}
