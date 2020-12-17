main() {
  repl();
}

repl() {
  running = 1;

  while (running) {
    putchar(63);
    putchar(32);

    c = getchar();

    print_num(c);
    puts();

    if (c == 113)
      running = 0;
  }
}

puts() { putchar(10); }

print_num(n) {
  if (n < 0) {
    putchar(45); // -
    n = -n;
  }

  if (n / 10) print_num(n / 10);

  putchar(n % 10 + 48);
}
