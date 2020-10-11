#ifndef HOLYCC_AST_HPP
#define HOLYCC_AST_HPP

#include <string>
#include <variant>

using namespace std::string_literals;

#include <holycc/token.hpp>

namespace holycc::ast {

// AST node
struct Node {
  enum class Type {
    ADD,
    SUB,
    DIV,
    MUL,
  };
  Type type;
  std::vector<std::variant<Node, std::string>> children;

  friend bool operator==(const Node &n1, const Node &n2) {
    return n1.type == n2.type && n1.children == n2.children;
  }

  Node(Type type) : type(type) { }
};

} // namespace holycc::ast
#endif // HOLYCC_AST_HPP
