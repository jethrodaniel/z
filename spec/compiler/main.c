// Since we load the entire file into memory, we don't have to forward-declare
// anything.
main() {
  fib(41); // We currently have an implicit return.
}

// Functions are typeless, that is, everything's an int
fib(n) {
  return n + g();
}
g() { 1; }
