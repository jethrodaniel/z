#include <catch.hpp>
#include <vector>

#include <holycc/parser.hpp>

using namespace std::string_literals;

TEST_CASE("parser") {
  holycc::Parser parser("42 + 5"s);

  auto node = parser.parse();

  holycc::ast::Node expected(holycc::ast::Node::Type::ADD);
  REQUIRE(node == expected);
}
