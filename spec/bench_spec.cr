require "./spec_helper"

code = <<-Z
  // comments
  main() {
    a = b = c = 42;
    f(a + b - c);
  }
  f(x) { g(x); }
  g(x) { x + 2; }
Z

it "benchmarks the lexer", tags: "bench" do
  n = 5_000_000
  Benchmark.bm do |x|
    x.report("lex:") do
      n.times do
        lex = Z::Lex::Lexer.new(code)
        lex.tokens
      end
    end
  end
end

it "benchmarks the parser", tags: "bench" do
  n = 5_000_000
  Benchmark.bm do |x|
    x.report("parser:") do
      n.times do
        node = Z::Parser.new(code).parse
      end
    end
  end
end
