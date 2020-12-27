int main() {
  repl();
}

int repl() {
  running = 1;

  prompt();

  while (running) {
    if ((c = getchar()) == 113) // q
      return running = 0;
    
    print_num(c);
    puts();
    if (c == -1) { // ^D // we get 4294967295 atm
      p(94);
      p(68);
    }

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

int p(c){putchar(c);}
int puts(){p(10);}

int prompt() {
  p(63); // ?
  p(32); // ' '
}

int print_num(n) {
  if (n < 0) {
    p(45); // -
    n = -n;
  }
  if (n / 10)
    print_num(n / 10);
  p(n % 10 + 48);
}
