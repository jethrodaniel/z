// test: final result should print `0`.
main() {
  n = test_while();
  putchar(48 + n);
}

test_while() {
  i = 10;

  while (i > 0) {
    i = i - 1;
  }

  i;
}
