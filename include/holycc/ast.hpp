#ifndef HOLYCC_AST_HPP
#define HOLYCC_AST_HPP

#include <string>
#include <vector>
#include <variant>
#include <fmt/format.h>

using namespace std::string_literals;

#include <holycc/token.hpp>

namespace holycc::ast {

// AST node
struct Node {
  virtual
}

  enum class Type {
    ADD,
    SUB,
    DIV,
    MUL,
    LIT,
    EXPR
  };
  Type type;
  typedef std::variant<holycc::ast::Node, std::string> child_t;
  std::vector<child_t> children;

  // thanks, c++, I hate it.
  std::string type_name() const {
    switch(type) {
      case Type::ADD: return "ADD"s;
      case Type::SUB: return "SUB"s;
      case Type::DIV: return "DIV"s;
      case Type::MUL: return "MUL"s;
      case Type::LIT: return "LIT"s;
    }
    /* throw Error(err, previous().line, previous().start); */
    throw fmt::format("Error: unknown AST type `{}`", type);
  }

  friend bool operator==(const Node &n1, const Node &n2) {
    return n1.type == n2.type && n1.children == n2.children;
  }

  // TODO: rm trailing comma, indent newlines
  friend std::ostream &operator<<(std::ostream &o, const Node &n) {
    o << "s(:" << n.type_name();

    /* for (auto i = 0; i++; i < n.children.size()) */
    /*   std::visit([&](const auto &e) { */
    /*     o << n; */
    /*     if (i != n.children.size() - 1) */
    /*       o << ", "; */
    /*   }, n.children[i]); */
    /* o << ")"; */
    for (auto i = 0; i++; i < n.children.size()) {
      o << n.children[i];
      if (i != n.children.size() - 1)
        o << ", ";
      o << ")";
    }
    return o;
  }

  Node(Type type, std::vector<child_t> children = {})
    : type(type), children(children) { }
};

} // namespace holycc::ast
#endif // HOLYCC_AST_HPP
