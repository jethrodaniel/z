#include <catch.hpp>

#include <holycc/ast.hpp>

TEST_CASE("AST") {
  holycc::ast::Node node(holycc::ast::Node::Type::ADD);

  std::vector<std::variant<holycc::ast::Node, std::string>> children;
  REQUIRE(node.children == children);
}
