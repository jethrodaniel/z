#ifndef HOLYCC_ERROR_HPP
#define HOLYCC_ERROR_HPP

#include <fmt/format.h>
using namespace std::string_literals;

namespace holycc {

struct Error : public std::exception {
  std::string msg;
  int line, column;

  const char * what() const throw () {
    auto err = fmt::format("[{}][{}] {}", line, column, msg);
    return err.c_str();
  }

  Error(std::string msg, int line, int column)
    : msg(msg), line(line), column(column) { }
};

} // namespace holycc
#endif // HOLYCC_ERROR_HPP
