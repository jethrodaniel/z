#ifndef HOLYCC_HOLYCC_HPP
#define HOLYCC_HOLYCC_HPP

#include <iostream>
#include <cstdio>
#include <string>

namespace holycc {

class Compiler {
public:
  Compiler();
  int run(int argc, char **argv);
};

} // namespace holycc
#endif // HOLYCC_HOLYCC_HPP
