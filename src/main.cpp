#include <holycc/compiler.hpp>

int main(int argc, char **argv) {
  holycc::Compiler cc;
  return cc.run(argc, argv);
}
