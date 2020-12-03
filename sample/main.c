f(x) {
  a = b = 5;
  t = b + 1;
}

fib(n) {
  //if (n <= 1)
  //  return n;
  fib(n-1) + fib(n-2); 
  f();
}

f() {}
f(x) {}
f(x, y) {}
f(x, y, z) {
  f(1);
  f(1, 2);
  f(1, 2, 3);
}
