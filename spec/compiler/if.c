// test: final result should print `0`.
main() {
  n = 0;
  n = n + test_if()
        + test_if_nested()
        + test_if_zero()
        + test_if_else()
        + test_if_else_braces();
  putchar(48 + n);
}

test_if() {
  if (2 > 4) return 2;
  if (2 > 4) return 2;
  if (2 < 4) return 0;
  42;
}

test_if_nested() {
  if (2 < 4) {
    if (2 <= 4)
      return 0;
  }
  42;
}

test_if_zero() {
  if (0) return 42;
  0;
}

test_if_else() {
  if (2 > 4) return 2;
  else if (0) return 3;
  else if (2 < 4) return 0;
  else return 42;
  42;
}

test_if_else_braces() {
  if (2 > 4) { return 2; }
  if (2 > 4)
    return 2;
  else if (0) {
    return 3;
  } else if (2 < 4) {
    return 0;
  } else {
    return 42;
  }
  42;
}
