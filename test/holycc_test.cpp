#include <catch.hpp>
#include <cstdlib>

#include <iostream>

#include <holycc/holycc.hpp>

int sh(const char * cmd) {
  return system(cmd);
}

TEST_CASE("holycc compiler input/output tests") {
  SECTION("simple program that reads an int and exits") {
    sh("mkdir -p tmp; ./bin/holycc 0 > tmp/out.s && cc -o tmp/a.out tmp/out.s");
    REQUIRE(sh("./tmp/a.out") == 0);
  }
}
