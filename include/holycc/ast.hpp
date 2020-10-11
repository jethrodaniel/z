#ifndef HOLYCC_AST_HPP
#define HOLYCC_AST_HPP

#include <string>

using namespace std::string_literals;

#include <holycc/token.hpp>

namespace holycc {

struct Node {
  friend bool operator==(const Node &n1, const Node &n2) {
    return true;
  }

  /* Token token; */
  /* Node(Token token) : token(token) { } */
  Node() { }
};

} // namespace holycc
#endif // HOLYCC_AST_HPP
