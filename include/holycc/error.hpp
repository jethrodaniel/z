#ifndef HOLYCC_ERROR_HPP
#define HOLYCC_ERROR_HPP

namespace holycc {

class Error : public std::exception {
  std::string msg;
  int line, column;

public:
  Error(std::string msg, int line, int column)
    : msg(msg), line(line), column(column) { }
};

} // namespace holycc
#endif // HOLYCC_ERROR_HPP
