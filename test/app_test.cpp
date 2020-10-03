#include <catch.hpp>

#include <app/app.hpp>

SCENARIO("app", "[app]") {
  GIVEN("something") {
    WHEN("something happens") {
      THEN("we get this") {
        REQUIRE(foo() == 0);
      }
    }
  }
}
