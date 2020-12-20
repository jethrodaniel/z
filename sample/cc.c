main() {
  repl();
}

repl() {
  running = 1;

  prompt();

  while (running) {
    if ((c = getchar()) == 113) // q
      return running = 0;
    
    print_num(c);
    puts();

    if (c == 10) { // \n
      p(61); // =
      p(62); // >
      p(32); // ' '
      print_num(c);
      puts();
      prompt();
    }
  }
}

p(c){putchar(c);}
puts(){p(10);}

prompt() {
  p(63); // ?
  p(32); // ' '
}

print_num(n) {
  if (n < 0) {
    p(45); // -
    n = -n;
  }
  if (n / 10)
    print_num(n / 10);
  p(n % 10 + 48);
}
