#define FMT_HEADER_ONLY // needed to use as a header only lib
#include <fmt/format.h>
#include <fmt/color.h>
#include <fmt/ranges.h>
#include <iostream>
#include <vector>

#include <holycc/cli.hpp>
#include <holycc/lexer.hpp>
#include <holycc/parser.hpp>
#include <holycc/compiler.hpp>

holycc::Compiler::Compiler() {
}

// = holycc
//
// == Language recognized so far:
//
// Takes as input a number or addition/subtraction, and exits with the
// result of the expression.

void run_lexer(std::string input) {
  holycc::Lexer lex(input);
  auto tokens = lex.scan_tokens();
  for (auto t : tokens)
    std::cout << t << "\n";
}

void run_parser(std::string input) {
  holycc::Parser parser(input);
  auto node = parser.parse();
  std::cout << node << "\n";
}

int run_compiler(std::string input) {
  char *c = input.data();
  fmt::print(".intel_syntax noprefix\n");
  fmt::print(".globl main\n");
  fmt::print("main:\n");
  fmt::print("  mov rax, {}\n", strtol(c, &c, 10));

  while (*c != 0) {
    if (*c == '+') {
      c++;
      fmt::print("  add rax, {}\n", strtol(c, &c, 10));
      continue;
    }

    if (*c == '-') {
      c++;
      fmt::print("  sub rax, {}\n", strtol(c, &c, 10));
      continue;
    }

    fmt::print(stderr, fg(fmt::color::red) | fmt::emphasis::bold, "Error: {}\n", *c);
    return 1;
  }

  fmt::print("  ret\n");
  return 0;
}

#define HOLYCC_VERSION "v0.1.0"

int holycc::Compiler::run(int argc, char **argv) {
  CLI::App app{"HolyC compiler\n"};
  app.set_version_flag("-V,--version", std::string(HOLYCC_VERSION));
  app.add_flag("-l, --lex", "Tokenize the input");
  app.add_flag("-p, --parse", "Parse the input");
  std::string input;
  app.add_option("input", input, "Input string")->required();

  CLI11_PARSE(app, argc, argv);

  try {
  if (app.count("--lex") > 0)
    run_lexer(input);
  if (app.count("--parse") > 0)
    run_parser(input);
  } catch(const std::string& e) {
    fmt::print("{}\n", e);
  } catch (const std::exception &e) {
    fmt::print("{}\n", e.what());
  }

  run_compiler(input);

  return 0;
}
