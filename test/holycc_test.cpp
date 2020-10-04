#include <catch.hpp>
#include <cstdlib>

#include <iostream>

#include <holycc/holycc.hpp>

// Run a shell command, return the exit code.
//
// We need `WEXITSTATUS` here, since Linux's `wait` returns `code << 8`.  See
// https://stackoverflow.com/a/22569908/7132678
int sh(const char *cmd) {
  int result = system(cmd);
  int code = WEXITSTATUS(result);
  printf("[%i] sh '%s'\n", code, cmd);
  return code;
}

int holyc(const char *code) {
  char *cmd;
	asprintf(&cmd, "./bin/holycc %s > a.S && cc a.S -o a.out && ./a.out", code);
  return sh(cmd);
}

TEST_CASE("holycc compiler input/output tests") {
  SECTION("simple program that reads an int and exits") {
    REQUIRE(holyc("42") == 42);
  }
  SECTION("addition/subtraction") {
    REQUIRE(holyc("42+1+2-1") == 44);
  }

  sh("rm -rf a.S a.out");
}
