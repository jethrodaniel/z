// A few notable differences from C
//
// - We load the entire file into memory, thus we don't have to forward-declare
// - We currently have an implicit return
// - Functions are typeless; everything's an int

main() {
  print_fib(0);
  print_fib(1);
  print_fib(2);
  print_fib(3);
  print_fib(4);
  print_fib(5);
  print_fib(6);
  print_fib(7);
  print_fib(8);
  print_fib(9);
  print_fib(10);
  print_fib(11);
  print_fib(12);

}

// prints `fib(n) = x`, for the given `n`
print_fib(n) {
  putchar(102);  // f
  putchar(105);  // i
  putchar(98);   // b
  putchar(40);   // (
  print_num(n);
  putchar(41);   // )
  putchar(32);   // ' '
  if (n < 10)
    putchar(32);
  putchar(61);   // =
  putchar(32);   // ' '
  print_num(fib(n));
  puts();
}

puts() {
  putchar(10); // \n
}

print_num(n) {
  if (n < 0) {
    putchar(45); // -
    n = -n;
  }

  if (n / 10) {
    print_num(n / 10);
    n = n - (n / 10) * 10;
  }

  putchar(n + 48);
}

fib(n) {
  if (n < 2) return n;

  fib(n-1) + fib(n-2);
}
