#ifndef HOLYCC_ERROR_HPP
#define HOLYCC_ERROR_HPP

#include <fmt/format.h>

using namespace std::string_literals;

namespace holycc {

// todo: nice err messages like
//
// ```
// src/compiler.cpp:39:37: error: expected ‘)’ before ‘{’ token
//    39 |   } catch (const std::exception & ex {
//       |           ~                         ^~
//       |
// ```
//
// // auto detail = "\n" + std::string("-", start) + "^\n";
// // error += detail;
//
struct Error : public std::exception {
  std::string msg;
  int line, column;

  const char* what() const throw () {
    auto err = fmt::format("[{}:{}] {}", line, column, msg);
    return err.c_str();
  }

  Error(std::string msg, int line, int column)
    : msg(msg), line(line), column(column) { }
};

} // namespace holycc
#endif // HOLYCC_ERROR_HPP
