#include <catch.hpp>
#include <vector>

#include <holycc/scanner.hpp>

using namespace std::string_literals;

TEST_CASE("scanner") {
  holycc::Scanner scanner("Be\nexcellent !"s);

  REQUIRE(scanner.pos == 0);
  REQUIRE(scanner.line == 1);
  REQUIRE(scanner.is_eof() == false);
  REQUIRE(scanner.advance() == "B");
  REQUIRE(scanner.advance() == "e");
  REQUIRE(scanner.advance() == "\n");
  REQUIRE(scanner.pos == 3);
  REQUIRE(scanner.line == 2);
  REQUIRE(scanner.advance() == "e");
  REQUIRE(scanner.advance() == "x");
  REQUIRE(scanner.advance() == "c");
  REQUIRE(scanner.advance() == "e");
  REQUIRE(scanner.advance() == "l");
  REQUIRE(scanner.advance() == "l");
  REQUIRE(scanner.advance() == "e");
  REQUIRE(scanner.advance() == "n");
  REQUIRE(scanner.advance() == "t");
  REQUIRE(scanner.advance() == " ");
  REQUIRE(scanner.advance() == "!");
  REQUIRE(scanner.is_eof() == true);
}
