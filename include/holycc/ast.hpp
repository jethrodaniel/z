#ifndef HOLYCC_AST_HPP
#define HOLYCC_AST_HPP

#include <string>
#include <vector>
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
  typedef std::variant<holycc::ast::Node, std::string> child_t;
  std::vector<child_t> children;

  // thanks, c++, I hate it.
  std::string type_name() const {
    switch(type) {
      case Type::ADD: return std::string("ADD");
      case Type::SUB: return std::string("SUB");
      case Type::DIV: return std::string("DIV");
      case Type::MUL: return std::string("MUL");
    }
    return "error!";
  }

  friend bool operator==(const Node &n1, const Node &n2) {
    return n1.type == n2.type && n1.children == n2.children;
  }

  // TODO: rm trailing comma, indent newlines
  friend std::ostream &operator<<(std::ostream &output, const Node &n) {
    output << "s(:" << n.type_name() << ", ";
    for (auto c : n.children)
      std::visit([&](const auto &e) { output << e << ", "; }, c);
    output << ")";
    return output;
  }

  Node(Type type, std::vector<child_t> children = {})
    : type(type), children(children) { }
};

} // namespace holycc::ast
#endif // HOLYCC_AST_HPP
