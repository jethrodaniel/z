main() {
  test_vars();
}

p(n) {
  putchar(48 + n);
  putchar(10);
}

test_vars() {
  a = b = c = 5;
  p(a);

  a = 4;
  p(a);

  b = a * (c - 3) - 5;
  p(b);

  c = (b = a)*2 - c - 1;
  p(c);

  p(a + b + 1 - c*4);
}
