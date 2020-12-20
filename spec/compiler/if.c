main() {
  // if
  if (3>2) p(65);
  if (-3>2) p(90);

  // if, else
  if (-4>2) p(90); else p(66);

  // if, else if, else
  if (-3>3) p(90);
  else if (2>0) p(67);
  else if (0)p(90);
  else p(90);

  // nesting
  if (0) { p(90); }
  else if (1) {
    p(68);
    if (3>4) p(90);
    else {
      p(69);
      if (1>2<3) p(70);else p(90);
    }
  } else p(90);
}

p(c){putchar(c);putchar(10);}
