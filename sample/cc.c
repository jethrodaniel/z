main() {
  repl();
}

repl() {
  running = 1;

  prompt();

  while (running) {
    c = getchar();

    if (c == 10) { // \n
      putchar(61); // =
      putchar(62); // >
      putchar(32); // ' '
      putchar(33); // !
      // puts line
      puts();
      prompt();
    }

    if (c == 113) // q
      running = 0;
    else {
      print_num(c);
      puts();
    }
  }
}

puts() { putchar(10); }

prompt() {
  putchar(63); // ?
  putchar(32); // ' '
}

print_num(n) {
  if (n < 0) {
    putchar(45); // -
    n = -n;
  }
  if (n / 10)
    print_num(n / 10);

  putchar(n % 10 + 48);
}
