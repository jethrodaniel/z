int main() {
  test_vars();
}

int p(n) {
  putchar(48 + n);
  putchar(10);
}

int test_vars() {
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
